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
	local log_path = skynet.getenv("statistic_path")
	local dir = log_path..date.."/"
	local attrib = lfs.attributes (dir)
	if not attrib then
		assert (lfs.mkdir(dir), "could not make a new directory")
	end
	local file_name = file..".log"
	if not self.log_mgr then
		self.log_mgr = skynet.queryservice("srv_log_mgr")
	end
	self.date = date
	self.fileHandle = skynet.call(self.log_mgr, "lua", "create", dir, file_name, date)
	self.fileName = file_name
	self.file = file
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
			open(self, file, date)
		end
		if self.date ~= date then
			open(self, file, date)
		end
		c.send(self.fileHandle, 0, 0, message)
		return true
	end)
	--设置等级
	log:setLevel(log_level)
	return log
end

return logging.file