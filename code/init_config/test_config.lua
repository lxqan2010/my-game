skynetroot = "./skynet/"
thread = 8
logger = nil
logpath = "./logs/landlord/test/"
harbor = 0
start = "test_main"	-- main script
bootstrap = "snlua bootstrap"	-- The service for bootstrap
cluster = "./landlord/cluster/clustername.lua"
testservice = "./landlord/?.lua;" ..
			"./service/?.lua;" ..
			"./landlord/service/?.lua;" ..
			"./landlord/test/?.lua;" ..
			"./test/?.lua"

luaservice = skynetroot .. "service/?.lua;".. testservice
lualoader = skynetroot .. "lualib/loader.lua"
preload = "./global/preload.lua"	-- run preload.lua before every lua service run
snax = testservice

cpath = skynetroot.."cservice/?.so;".."./cservice/?.so" 
-- daemon = "./skynet-test.pid"
nodename = "test"

lua_path = skynetroot .. "lualib/?.lua;" ..
		   "./lualib/?.lua;" ..
           "./lualib/logger/?.lua;" ..
		   "./global/?.lua;" ..
		   "./hotfix/?.lua;" ..
		   "./landlord/lib/?.lua;" ..
		   "./landlord/data/?.lua;" ..
		   "./landlord/data/config/server/?.lua;" ..
		   "./landlord/etc/?.lua;" ..
		   "./landlord/?.lua;" ..
		   "./service/?.lua;".. 
		   "./landlord/test/?.lua;" ..
		   "./test/?.lua"
		   

lua_cpath = skynetroot .. "luaclib/?.so;" .. "./luaclib/?.so"
