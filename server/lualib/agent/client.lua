local skynet = require "skynet"
local snax = require "skynet.snax"
local socket = require "skynet.socket"

local logger = file_log("client")

-- 协议事件处理
local SPROTO_PROCESS = { 
    C2S = {},
    C2S_ARRAY = {},
    C2S_BEFORE_ARRAY = {},
    C2S_AFTER_ARRAY = {},
    
    S2C_BEFORE_ARRAY = {},
    S2C_AFTER_ARRAY = {},
}

-- 用户事件处理器
local CLIENT_EVENT = {}     -- ARRAY {{name,process(self, ...)}, ...}

local HOST 
local HOST_REQUEST 

local root = {}

function root.configure(host, host_request)
    HOST = HOST
    HOST_REQUEST = host_request
end

-- 注册用户事件处理器
function root.use(name, process)
    table.insert(CLIENT_EVENT, {name, process})
end

function root.c2s_use(name, process)
    SPROTO_PROCESS.C2S[name] = process
    table.insert(SPROTO_PROCESS.C2S_ARRAY, {name, process})
end

function root.c2s_after(name, process)
    table.insert(SPROTO_PROCESS.C2S_AFTER_ARRAY, {name, process})
end

function root.c2s_before(name, process)
    table.insert(SPROTO_PROCESS.C2S_BEFORE_ARRAY, {name, process})
end

function root.s2c_before(name, process)
    table.insert(SPROTO_PROCESS.S2C_BEFORE_ARRAY, {name, process})
end

function root.s2c_after(name, process)
    table.insert(SPROTO_PROCESS.S2C_AFTER_ARRAY, {name, process})
end

function root.close_use(process)
    table.insert(CLOSE_PROCESS, process)
end

function root.auth(...)
    -- 默认处理函数是不通过！
    return false
end

-- 默认c2s处理器
local function not_found_c2s_process(self, name, args)
    logger:debug("session %s c2s %s args %s not found", tostring(self.session), name, tostring(args))
    return {code = 400, err = name .. "not found " }
end

local function match_process(patterns, name, self, ...)
    for _, v in ipairs(patterns) do
        local pattern, f = table.unpack(v) 
        if string.match(name, pattern) then
            local ok, args = f(self, name, ...)
            if not ok then
                return ok, args
            end
        end
    end
    return true
end

local function c2s_process(self, name, args)
    local f = SPROTO_PROCESS.C2S[name]
    if f then 
        return f(self, name, args)
    end

    for _, v in ipairs(SPROTO_PROCESS.C2S_ARRAY) do
        local pattern, f = table.unpack(v) 
        if string.match(name, pattern) then
            return f(self, name, args)
        end
    end
    return not_found_c2s_process(self, name, args)
end

local function c2s_after(self, name, args, res, ok, err, ...)
    return match_process(SPROTO_PROCESS.C2S_AFTER_ARRAY, name, self, args, res, ok, err, ...)
end

local function c2s_before(self, name, args, ...)
    return match_process(SPROTO_PROCESS.C2S_BEFORE_ARRAY, name, self, args, ...)
end

local function s2c_after(self, name, args, ok, err, ...)
    return match_process(SPROTO_PROCESS.S2C_AFTER_ARRAY, name, self, args, ok, err, ...)
end

local function s2c_before(self, name, args, ...)
    return match_process(SPROTO_PROCESS.S2C_BEFORE_ARRAY, name, self, args, ...)
end

-- session = {fd = fd, uid = uid, agent = agent}
function root:new()
    local o = { session = {} }
    setmetatable(o, {__index = self})
    return o
end

local function send_package(fd, pack)
    if not fd then
        return false
    end
    local package = string.pack(">s2", pack)
    return socket.write(fd, package)
end

function root:s2c_send_package(name, msg, pack)
    local ok = s2c_before(self, name, args, msg, ok, data)
    if not ok then
        return
    end
    local ok, data = send_package(self.session.fd, pack)
    if not ok then
        data = "socket write error"
    end
    s2c_after(self, name, args, msg, ok, data)
end

function root:s2c_request(name, args)
    local ok = s2c_before(self, name, args)
    if not ok then
        return
    end
    local ok, data = pcall(HOST_REQUEST, name, args)
    if ok then
        ok = send_package(self.session.fd, data)
        if not ok then
            data = "socket write error"
        end
    end
    s2c_after(self, name, args, ok, data)
end

local function response_processs(self, response, res)
    if not response then
        return true
    end
    local ok, rs = pcall(response, res)
    if not ok then
        res = {code = 400}
        local err = "sproto error ".. rs
        local rs  = response(res)
        send_package(self.session.fd, rs)
        return ok, err
    end
    return send_package(self.session.fd, rs)
end

-- 处理sproto 请求协议入口
function root:sproto_request(name, args, response)
    local trace_err
    local trace = function ()
        trace_err = debug.traceback()
    end
    local ok, goon, res = xpcall(c2s_before, trace, self, name, args)

    if not ok then
        logger:error("c2s before name %s args %s err %s", name, tostring(args), trace_err)
        res = res or {code = 400, err = trace_err}
        response_processs(self, response, res)
        ok = xpcall(c2s_after, trace, self, name, args, res, ok, trace_err)
        if not ok then
            logger:error("c2s_after name %s args %s res %s err %s", name, tostring(args), tostring(res), trace_err)
        end
        return
    end
    if not goon then                                            -- BEFORE停止了 处理
        if not response then
            return
        end
        res = res or {code = 400, err = "stop by before process"}
        local ok, err = response_processs(self, response, res)
        ok = xpcall(c2s_after, trace, self, name, args, res, ok, err)
        if not ok then
            logger:error("c2s_after name %s args %s res %s err %s", name, tostring(args), tostring(res), trace_err)
        end
        return
    end

    local ok, res = xpcall(c2s_process, trace, self, name, args)   -- 处理请求
    if not ok then                      
        logger:error("c2s process name %s args %s err %s", name, tostring(args), trace_err)
        if response then
            res = res or {code = 400, err = trace_err}
            response_processs(self, response, res)
        end
        ok = xpcall(c2s_after, trace, self, name, args, res, ok, trace_err)
        if not ok then
            logger:error("c2s_after name %s args %s res %s err %s", name, tostring(args), tostring(res), trace_err)
        end
        return 
    end

    ok, err = response_processs(self, response, res)
    local ok = xpcall(c2s_after,trace, self, name, args, res, ok, err)
    if not ok then
        logger:error("c2s_after name %s args %s res %s err %s", name, tostring(args), tostring(res), trace_err)
    end
end

-- 触发事件
function root:trigger(name, ...)
    return match_process(CLIENT_EVENT, name, self, ...)
end

return root