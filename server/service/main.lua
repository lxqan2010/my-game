local skynet = require "skynet"

local function main()
    -- skynet.error("init services ..")

    -- -- 是否开启控制台指令
    -- local console_port = skynet.getenv("console_port")
    -- skynet.newservice("debug_console", console_port)

    -- local daemon = skynet.getenv("daemon")
    -- if not daemon then 
    --     skynet.newservice("srv_console")
    -- end

    -- skynet.exit()

    skynet.error("Server start")

	skynet.uniqueservice("protoloader")
    
    if not skynet.getenv "daemon" then
		local console = skynet.newservice("console")
	end
    
    skynet.newservice("debug_console",8000)
	skynet.newservice("simpledb")
    
    local watchdog = skynet.newservice("watchdog")
    
    skynet.call(watchdog, "lua", "start", {
		port = 8888,
		maxclient = max_client,
		nodelay = true,
	})
    
    skynet.error("Watchdog listen on", 8888)
    skynet.exit()
    
end

skynet.start(main)
