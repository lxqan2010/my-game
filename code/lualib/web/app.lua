local snax = require "skynet.snax"
local skynet = require "skynet"
local logger = file_log("web")
local access_logger = file_log("access")

local PROCESS = {
    ALL = {},
    ALL_ARRAY = {},
    POST = {},
    POST_ARRAY = {},
    GET = {},
    GET_ARRAY = {},
    AFTER_ARRAY = {},
    BEFORE_ARRAY = {},
}

local function not_found_process(req, res)
    logger:warn("%s %s not found", req.method, req.url)
    res.code = 404
    res.body = "<html><head><title>404 Not Found</title></head><body> <p>404 Not Found</p></body></html>"
    res.headers["Content-Type"]="text/html"
end

local function internal_server_error(req, res, errmsg)
    logger:error("internal_server_error %s %s error %s", req.method, req.url, errmsg)
    res.code = 500
    res.body = "<html><head><title>Internal Server Error</title></head><body> <p>500 Internal Server Error</p></body></html>"
    res.headers["Content-Type"]="text/html"
    return res.code, res.body, res.headers
end

local web = {}

local function pre_pattern(path)
    local keys = {}
    for k in string.gmatch(path, "/:(%w+)") do
        table.insert(keys, k)
    end
    if #keys == 0 then
        return path
    end
    local pattern = string.gsub(path, "/:(%w+)", "/(%%w+)")
    return pattern, keys
end


function web.use(path, process)
    local pattern, keys = pre_pattern(path)
    PROCESS.ALL[path] = process
    table.insert(PROCESS.ALL_ARRAY, {path= path, pattern = pattern, keys=keys, process = process})
end

function web.get(path, process)
    local pattern, keys = pre_pattern(path)
    PROCESS.GET[path] = process
    table.insert(PROCESS.GET_ARRAY, {path = path, pattern = pattern, keys=keys, process = process})
end

function web.post(path, process)
    local pattern, keys = pre_pattern(path)
    PROCESS.POST[path] = process
    table.insert(PROCESS.POST_ARRAY, {path = path, pattern = pattern, keys=keys, process = process})
end

-- 请求处理前，要做的处理
function web.after(path, process)
    table.insert(PROCESS.AFTER_ARRAY, {pattern = path, process = process})
end

-- 请求处理后，要做的处理
function web.before(path, process)
    table.insert(PROCESS.BEFORE_ARRAY, {pattern = path, process = process})
end

-- TODO: 静态文件下载
function web.static(path, dir)
    
end

-- TODO: 增加高级路由支持
function web.router()
    -- body
end

local REQ = {
--    ip = "192.168.1.123",
--    url = "/",
--    method = "GET",
--    body = "xx=xxx",
--    headers = {},
--    path = "",
}

local RES = {
--     code = 200
--     headers = {},
--     body = "",
--     hostname = "res.52jiami.com",
}

function RES:json(tbl)
    local ok, body = pcall(cjson_encode, tbl)
    self.headers["Content-Type"] = 'application/json'
    self.body = body
end

function RES:status(code)
    self.code = code
end


local function match_process(patterns, path)
    if not patterns then
        return
    end
    local match
    for _, v in ipairs(patterns) do
        if string.match(path, v.pattern) then
            match = v
            break
        end
    end
    if match then
        return match
    end
end


local function before_process( req, res)
    for _, v in ipairs(PROCESS.BEFORE_ARRAY) do 
        if string.match(req.path, v.pattern) then 
            if not v.process(req, res) then
                return false
            end
        end
    end
    return true
end

local function after_process(req, res)
    for _, v in ipairs(PROCESS.AFTER_ARRAY) do
        if string.match(req.path, v.pattern) then
            if not v.process(req, res) then
                return false
            end
        end
    end
    return true
end

local function process(req, res)
    local method = PROCESS[req.method]
    if method then
        local f = method[req.path]
        if f then
            return f(req, res)
        end
    end

    local f = PROCESS.ALL[req.path]
    if f then
        return f(req, res)
    end

    -- 正则表达式匹配支持
    local match = match_process(PROCESS[req.method .. "_ARRAY"], req.path)
    if not match then
        match = match_process(PROCESS["ALL_ARRAY"], req.path)
    end
    if not match then                               -- 404 not found
        return not_found_process(req, res)
    end

    req.pattern = match.path                    -- 选中的匹配模式
    if not match.keys then                      -- 
        return f(req, res)
    end
    local args = table.pack(string.match(req.path, match.pattern))
    local params = {}
    for k,v in ipairs(args) do 
        params[match.keys[k]] = v
    end
    req.params = params
    match.process(req, res)
end


--处理http请求
function web.http_request(ip, url, method, headers, path, query, body)
    access_logger:info("%s %s %s", ip, method, url)
    local req = {ip = ip, url = url, method = method, headers = headers, 
            path = path, query = query, body = body}
    local res = {code = 200, body = nil, headers = {}}

    setmetatable(req, {__index = REQ})
    setmetatable(res, {__index = RES})
    local ok, r = xpcall(before_process, debug.traceback, req, res)
    if not ok then
        return internal_server_error(req, res, r)
    elseif not r then                                   -- 终止这次请求
        return res.code, res.body, res.headers
    end

    ok, r = xpcall(process, debug.traceback, req, res)
    if not ok then
        return internal_server_error(req, res, r)
    end

    ok, r = xpcall(after_process, debug.traceback, req, res)
    if not ok then
        return internal_server_error(req, res, r)
    end
    return res.code, res.body, res.headers
end

return web
