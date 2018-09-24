-- 控制台输出
-- Created by IntelliJ IDEA.
-- User: wjb
-- Date: 16/12/8
-- Time: 下午1:56

local logging = require "logging"

function logging.console()
	return logging.new( function(self, level, message)
		local date_time = os.date("%H:%M:%S")
		if not self.logPattern then
			self.logPattern = "[%date] [%level] %message"
		end
		io.stdout:write(logging.prepareLogMsg(self.logPattern, date_time, level, message))
		return true
	end)
end

return logging.console