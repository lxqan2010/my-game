skynetroot = "./skynet/"
thread = 8
logger = nil
logpath = "./logs/landlord/login/"
harbor = 0
start = "login_main"	-- main script
bootstrap = "snlua bootstrap"	-- The service for bootstrap
cluster = "./landlord/cluster/clustername.lua"
loginservice = "./landlord/?.lua;" ..
			"./service/?.lua;" ..
			"./landlord/service/?.lua;"..
			"./landlord/login/?.lua;" ..
            "./landlord/login/login_service/?.lua;"..
			"./landlord/test/?.lua;" ..
			"./test/?.lua"

luaservice = skynetroot .. "service/?.lua;".. loginservice
lualoader = skynetroot .. "lualib/loader.lua"
preload = "./global/preload.lua"	-- run preload.lua before every lua service run
snax = loginservice

cpath = skynetroot.."cservice/?.so;".."./cservice/?.so" 
-- daemon = "./skynet-login.pid"
nodename = "login"
http_port = 37001
console_port = 9100

game1 = "lddz1.52jiami.com:11000"
game2 = "lddz2.52jiami.com:11001"

test = 1
identity = 1
statistic_path = "./logs/landlord/statistic_login/"

lua_path = skynetroot .. "lualib/?.lua;" ..
		   "./lualib/?.lua;" ..
           "./lualib/logger/?.lua;" ..
		   "./global/?.lua;" ..
		   "./hotfix/?.lua;" ..
		   "./landlord/lib/?.lua;" ..
		   "./landlord/data/?.lua;" ..
		   "./landlord/etc/?.lua;" ..
           "./landlord/service/?.lua;" ..
		   "./landlord/?.lua;" ..
		   "./service/?.lua;".. 
		   "./landlord/login/?.lua;" ..
           "./landlord/login/login_service/?.lua;"..
		   "./landlord/test/?.lua;" ..
		   "./test/?.lua"

lua_cpath = skynetroot .. "luaclib/?.so;" .. "./luaclib/?.so"
