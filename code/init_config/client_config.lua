skynetroot = "./skynet/"
thread = 8
logger = nil
logpath = "./logs/client/"
harbor = 0
start = "client_main"	-- main script
bootstrap = "snlua bootstrap"	-- The service for bootstrap
cluster = "./landlord/cluster/clustername.lua"
loginservice = "./landlord/?.lua;" ..
			"./service/?.lua;" ..
			"./landlord/service/?.lua;"..
			"./landlord/clientlog/?.lua;" ..
            "./landlord/clientlog/client_service/?.lua;"..
			"./landlord/test/?.lua;" ..
			"./test/?.lua"

luaservice = skynetroot .. "service/?.lua;".. loginservice
lualoader = skynetroot .. "lualib/loader.lua"
preload = "./global/preload.lua"	-- run preload.lua before every lua service run
snax = loginservice

cpath = skynetroot.."cservice/?.so;".."./cservice/?.so" 
-- daemon = "./skynet-login.pid"
http_port=7010
console_port = 5011
statistic_path = "./logs/statistic_client/"
resource_path = "/Users/wjb/r_data/resource/images/" --资源路径
nodename = "clientlog"

lua_path = skynetroot .. "lualib/?.lua;" ..
		   "./lualib/?.lua;" ..
		   "./lualib/logger/?.lua;" ..
		   "./global/?.lua;" ..
		   "./hotfix/?.lua;" ..
		   "./landlord/lib/?.lua;" ..
		   "./landlord/data/?.lua;" ..
		   "./landlord/etc/?.lua;" ..
           "./landlord/service/?.lua;"..
		   "./landlord/?.lua;" ..
		   "./service/?.lua;".. 
		   "./landlord/clientlog/?.lua;" ..
           "./landlord/clientlog/client_service/?.lua;"..
		   "./landlord/test/?.lua;" ..
		   "./test/?.lua"

lua_cpath = skynetroot .. "luaclib/?.so;" .. "./luaclib/?.so"
