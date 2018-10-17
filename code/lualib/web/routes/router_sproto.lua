local sproto = require "sproto"
local code = require "code"
local md5 = require "md5"
local logger = file_log("web_sproto")

local WEB_HOST 
local DEFAULT_REQUEST = {}
local PROCESS = {}
local AFTER_PROCESS = {}
local BEFORE_PROCESS = {}

local MD5_SALT = ""

local web = {}

function web.use(name, process)
    table.insert(PROCESS, {name = name, process = process})
end

function web.before(name, process)
    table.insert(BEFORE_PROCESS, {name = name, process = process})
end

function web.after(name, process)
    table.insert(AFTER_PROCESS, {name = name, process = process})
end

function web.configure(request, salt, sproto_host)
    DEFAULT_REQUEST = request or DEFAULT_REQUEST
    MD5_SALT = salt
    WEB_HOST = sproto_host
end

local function proto_process(req, name, args)
    for _, v in ipairs(PROCESS) do 
        if string.match(name, v.name) then
            return v.process(req, name, args, res)
        end
    end
end

local function match_process(patterns, req, name, args, ...)
    for _, v in ipairs(patterns) do 
        if string.match(name, v.name) then
            local ok, res = v.process(req, name, args, ...) 
            if not ok then
                return ok, res
            end
        end
    end
    return true
end

local function process_response(name, args, response, rs)
    if not response then
        return
    end
    local ok, data = pcall(response, rs)
    if ok then
        return data
    end
    logger:error("sproto %s args %s serialize %s error %s ", name, tostring(args), tostring(rs), data)
    ok, data = pcall(response, {code = 404})
    return data
end

local function sproto_check_sign(sign, body)
    local gen_sign = md5.sumhexa(body.. MD5_SALT)
    if gen_sign ~= sign then
        logger:info("body sign %s req sign %s", gen_sign, sign)
    end
    return gen_sign == sign
end

-- 路由查找处理请求方法
local function proto_router(name)
    local pos = string.find(name, "_", 1, true)
    if not pos then
        return nil
    end
    
    local pp = string.sub(name, 1, pos - 1)
    local cmd = string.sub(name, pos + 1, #name)
    if not DEFAULT_REQUEST[pp] or not DEFAULT_REQUEST[pp][cmd] then
        return nil
    end
    return DEFAULT_REQUEST[pp][cmd]
end

function web.default_process(req, name, args)
    local f = proto_router(name)                     -- 路由请求方法
    if not f then
        logger:error("request not found %s", name)
        return {code = code.REQUEST_NOT_FOUND}
    end
    local err = ""
    local trace = function ()
        err = debug.traceback()
    end
    local ok, r = xpcall(f, trace, req, args) 
    if not ok then
        logger:error("request %s args %s error  %s", name, tostring(args), err)
        return {code = code.UNKNOWN}
    end
    return r 
end


function web.process(req, res)      
    local sz = req.headers["Content-Length"]
    local body = req.body
    sz = sz or #body
    local sign = req.query.sign 
    if not sign then
        logger:info("request not sign")
        res.code = 404
        res:json({code = code.TOKEN_AUTH_FAIL})
        return  
    end
    if not sproto_check_sign(sign, req.body) then
        res.code = 404
        res:json({code = code.TOKEN_AUTH_FAIL})
        return
    end
    local ok , type, name, args, response = pcall(WEB_HOST.dispatch, WEB_HOST, req.body, sz)
    if not ok then
        local err = string.format("sproto dispatch error %s", type or "null")
        res.code = 404
        res:json({code = code.UNKNOWN, err = err})
        logger:error(err)
        return
    end

    local err = ""
    local trace = function ()
        err = debug.traceback()
    end
    local ok, goon, rs = xpcall(match_process, trace, BEFORE_PROCESS, req, name, args)
    if not ok then
        logger:error("sproto %s args %s error %s", name, tostring(args), err)
    end
    if not ok or not goon then
        res.body = process_response(name, args, response, rs)
        return
    end

    local ok, rs = xpcall(proto_process, trace, req, name, args)
    if not ok then
        logger:error("sproto %s args %s error %s", name, tostring(args), err)
        rs = {code = 404, err = err}
    end
    res.body = process_response(name, args, response, rs)
    local ok = xpcall(match_process, trace, AFTER_PROCESS, req, name, args, ok, rs)
    if not ok then
        logger:error("sproto %s args %s error %s", name, tostring(args), err)
    end
end

return web
