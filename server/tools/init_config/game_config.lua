skynetroot = "./skynet/"
thread = 8
logger = nil
logpath = "./logs/landlord/game/"
harbor = 0
standalone="0.0.0.0:5100"
master="0.0.0.0:5100"
address="0.0.0.0:5200"
start = "game_main"	-- main script
bootstrap = "snlua bootstrap"	-- The service for bootstrap
cluster = "./landlord/cluster/clustername.lua"
gameservice = "./landlord/?.lua;" ..
			"./service/?.lua;" ..
			"./landlord/service/?.lua;" ..
			"./landlord/game/agent/?.lua;" ..
            "./landlord/game/game_service/?.lua;"..
			"./landlord/game/router/?.lua;"..
			"./landlord/game/?.lua;" ..
			"./landlord/test/?.lua;" ..
			"./test/?.lua"


luaservice = skynetroot .. "service/?.lua;".. gameservice
lualoader = skynetroot .. "lualib/loader.lua"
preload = "./global/preload.lua"	-- run preload.lua before every lua service run
snax = gameservice

cpath = skynetroot.."cservice/?.so;".."./cservice/?.so" 
-- daemon = "./skynet-game.pid"
nodename = "game"
ip = "192.168.1.230" --返回给登录服的ip
image_ip = "127.0.0.1:7010" --头像保存ip地址

port=11000 							-- 长链接端口
http_port=7002 						-- http端口
console_port = 3200                 -- 控制台端口

maxclient = 0
resource_path = "/Users/wjb/r_data/resource/images/"
statistic_path = "./logs/landlord/statistic_game/"

lua_path = skynetroot .. "lualib/?.lua;" ..
		   "./lualib/?.lua;" ..
		   "./lualib/logger/?.lua;" ..
		   "./global/?.lua;" ..
		   "./hotfix/?.lua;" ..
		   "./landlord/lib/?.lua;" ..
		   "./landlord/data/?.lua;" ..
		   "./landlord/data/config/?.lua;" ..
		   "./landlord/etc/?.lua;" ..
           "./landlord/service/?.lua;" ..
		   "./landlord/?.lua;" ..
		   "./service/?.lua;".. 
		   "./landlord/game/agent/?.lua;" ..
           "./landlord/game/game_service/?.lua;"..
		   "./landlord/game/router/?.lua;"..
		   "./landlord/game/?.lua;" ..
		   "./landlord/test/?.lua;" ..
		   "./test/?.lua"
		   

lua_cpath = skynetroot .. "luaclib/?.so;" ..
		   "./luaclib/?.so;"..
		   "./luafilesystem/src/?.so"
