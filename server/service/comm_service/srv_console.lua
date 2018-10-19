-- 热更新上层逻辑
-- Created by vs code.
-- User: lxquan
-- Date: 
-- Time: 

local skynet = require "skynet"
local snax   = require "skynet.snax"
local socket = require "skynet.socket"

local function split_cmdline(cmdline)
	local split = {}
	for i in string.gmatch(cmdline, "%S+") do
		table.insert(split,i)
	end
	return split
end

local function console_main_loop()
	local stdin = socket.stdin()
	socket.lock(stdin)
	while true do
		local cmdline = socket.readline(stdin, "\n")
		local split = split_cmdline(cmdline)
		local command = split[1]

		skynet.error("command: "..command)

		if command == "snax" then
			pcall(snax.newservice, select(2, table.unpack(split)))
		elseif command == "skynet" then
			pcall(skynet.newservice, select(2, table.unpack(split)))
		elseif command == "test" then
            local test_handle = skynet.localname(".testclient_"..split[2])
            skynet.send(test_handle, "lua", select(3, table.unpack(split)))
		elseif command == "hotfix" then
			skynet.error("hotfix...")
            local hotfix_handle = skynet.localname(".hotfix")
            skynet.call(hotfix_handle, "lua", select(2, table.unpack(split)))
        else
            print("unknown command")
		end
	end
	socket.unlock(stdin)
end

skynet.start(function()
	skynet.fork(console_main_loop)
end)
