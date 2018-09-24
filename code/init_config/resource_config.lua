skynetroot = "./skynet/"
thread = 2
logger = nil
logpath = "./logs/landlord/resource/"
harbor = 0
start = "resource_main"	-- main script
bootstrap = "snlua bootstrap"	-- The service for bootstrap
cluster = "./landlord/cluster/clustername.lua"
resourceservice = "./landlord/?.lua;" ..
			"./service/?.lua;" ..
			"./landlord/service/?.lua;"..
			"./landlord/resource/?.lua;" ..
            "./landlord/resource/resource_service/?.lua;"..
			"./landlord/test/?.lua;" ..
			"./test/?.lua"

luaservice = skynetroot .. "service/?.lua;".. loginservice
lualoader = skynetroot .. "lualib/loader.lua"
preload = "./global/preload.lua"	-- run preload.lua before every lua service run
snax = resourceservice

cpath = skynetroot.."cservice/?.so;".."./cservice/?.so" 
-- daemon = "./skynet-login.pid"
nodename = "resource"
http_port=7003

test = 1

lua_path = skynetroot .. "lualib/?.lua;" ..
		   "./lualib/?.lua;" ..
		   "./global/?.lua;" ..
		   "./landlord/lib/?.lua;" ..
		   "./landlord/data/?.lua;" ..
		   "./landlord/etc/?.lua;" ..
           "./landlord/service/?.lua;" ..
		   "./landlord/?.lua;" ..
		   "./service/?.lua;".. 
		   "./landlord/resource/?.lua;" ..
           "./landlord/resource/resource_service/?.lua;"..
		   "./landlord/test/?.lua;" ..
		   "./test/?.lua"

lua_cpath = skynetroot .. "luaclib/?.so;" .. "./luaclib/?.so"
