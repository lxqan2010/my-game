local skynet = require "skynet"
local skynet_core = require "skynet.core"
local snax = require "skynet.snax"
local log_config = require "log_config"

local levels = {"DEBUG", "INFO", "WARN", "ERROR", "FATAL"}
local Logger = {
    level = 0,
    logger = nil,                   -- c service logger handle
    date = nil,                     -- 2015-02-03
    file = "",                      --日志文件前缀
    filename = "",                  --当前打开日志文件名
    logger_mode = nil,
    logger_dir = nil,
}

function Logger.get_logger(file)
    local o = {}
    setmetatable(o, {__index = Logger})
    o.file = file
    local logger = {}
    local function get_logger(name)
        return function (...)
            local f = o[name]
            f(o, ...)
        end
    end
    logger.debug = get_logger("debug")
    logger.info = get_logger("info")
    logger.warn = get_logger("warn")
    logger.error = get_logger("error")
    logger.fatal = get_logger("fatal")
    logger.raw_log = get_logger("raw_log")

    logger.set_level = function (level)
        o:set_level(level)
    end
    return logger
end

function Logger:new(file)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.file = file
    return o
end


-- 获取日志级别 level is number
function Logger:get_logger_level()
    local level
    for k, v in ipairs(log_config) do
        if v.filename == self.file then
            level = v.level
            break
        end
    end
    if not level then
        level = self.logger_mode
    end
    for k, v in ipairs(levels) do
        if v == level then
            return k
        end
    end
    return 1
end

function Logger:open()
    local date = os.date("%Y-%m-%d", skynet_time())
    if not self.logger_mode then
        self.logger_mode = skynet.getenv("logmode") or "DEBUG"
        self.level = self:get_logger_level()                    -- 设置日志级别
    end
    
    self.logger_dir = skynet.getenv("logpath")         
    local filename = self.logger_dir..self.file.."-"..date..".log"
    local logger = self.logger_sup.req.get(filename)
    if not logger then
        logger = self.logger_sup.req.create(filename)
    end
    self.filename = filename
    self.logger = logger
end

function Logger:set_level(level)
    self.level = level
end

function Logger:log(level, fmt, ... )
    local now = skynet_time()
    local date = os.date("%Y-%m-%d", now)
    if not self.logger then             --日志文件还没有打开
        self.date = date
        self.logger_sup = snax.queryservice("srv_logger_sup")
        self:open()
        if self.level > level then
            return
        end
    end
    if os.date("%Y-%m-%d", now) ~= self.date then
        self.logger_sup.post.close(self.filename)
        self.date = date
        self:open()
    end
    --加入行号和文件名
    local info = debug.getinfo(4,"nSl")
    local s = string.format("[%s] [%s] [::%s] [line:%-4d] "..fmt, os.date("%H:%M:%S", now),
        levels[level], info.source, info.currentline, ...)
    print(s)
    skynet_core.send(self.logger, 0, 0, s) 
    
    if level >= 3 then
        s =  string.format("[%s] [%s] ["..self.filename.."] "..fmt, os.date("%H:%M:%S", now), levels[level], ...) 
        skynet.error(s)
    end
end

-- 原始日志，不设级别，不打印时间,不换自动换行
function Logger:raw_log(fmt, ...)
    local now = skynet_time()
    local date = os.date("%Y-%m-%d", now)
    if not self.logger then             --日志文件还没有打开
        self.date = date
        self.logger_sup = snax.queryservice("srv_logger_sup")
        self:open()
    end
    if os.date("%Y-%m-%d", now) ~= self.date then
        self.logger_sup.post.close(self.filename)
        self.date = date
        self:open()
    end
    local s = string.format(fmt, ...)
    skynet_core.send(self.logger, 1, 0, s)    
end

function Logger:debug( ... )
    if self.level > 1 then
        return
    end
    self:log(1, ...)
end

function Logger:info( ... )
    if self.level > 2 then
        return
    end
    self:log(2, ...)
end

function Logger:warn( ... )
    if self.level > 3 then
        return
    end
    self:log(3, ...)
end

function Logger:error( ... )
    if self.level > 4 then
        return
    end
    self:log(4, ...)
end

function Logger:fatal( ... )
    self:log(5, ...)
end

return Logger

