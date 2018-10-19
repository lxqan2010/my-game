-- 文件日志
-- Created by IntelliJ IDEA.
-- User: wjb
-- Date: 16/12/8
-- Time: 下午2:07

local skynet = require "skynet"
local c = require "skynet.core"
local logging = require "logging"
local log_config = require "log_config"
local lfs = require "lfs"

--开启日志
local function open(self, file, date)
	file = file or self.file
	local log_path = skynet.getenv("logpath")
	local dir = log_path..date.."/"
	local attrib = lfs.attributes (dir)
	if not attrib then
		if not lfs.mkdir(dir) then
			--再次获取
			local attrib = lfs.attributes (dir)
            if not attrib then
				return false
			end
		end
	end
	local file_name = file..".log"
	if not self.log_mgr then
		self.log_mgr = skynet.queryservice("srv_log_mgr")
	end
	self.date = date
	self.fileHandle = skynet.call(self.log_mgr, "lua", "create", dir, file_name, date)
	self.fileName = file_name
	self.file = file
	self.logPattern = "[%date] [%level] %message"
	return true
end

--写文件
function logging.file(file)
	local log_level = log_config[file] or "DEBUG"
	if type(file) ~= "string" then
		file = "lualog"
	end

	local log = logging.new(function(self, level, message)
		--创建日志文件服务
		local date = os.date("%Y-%m-%d")
		if not self.fileHandle then
			if not open(self, file, date) then
				return false
			end
        end
        if self.date ~= date then
			if not open(self, file, date) then
				return false
			end
		end
		local time = os.date("%H:%M:%S")
		local s = logging.prepareLogMsg(self.logPattern, time, level, message)
		c.send(self.fileHandle, 0, 0, s)
		local order = self.idenLevel[level]
		local warn_order = self.idenLevel["WARN"]
		if order >= warn_order then
			s =  string.format("[%s] [%s] [%s] ["..self.fileName.."] %s", date, time, level, message)
			skynet.error(s)
		end
		return true
	end)
	--设置等级
	log:setLevel(log_level)
	return log
end

return logging.file