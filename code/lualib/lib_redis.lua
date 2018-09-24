local skynet = require "skynet"

local redis_mgr

function do_redis(uid, cmd, ...)
    assert(cmd, "redis command is nil")
    if not redis_handle then
        if not redis_mgr then
            redis_mgr = skynet.queryservice("srv_redis_mgr")
        end
        local ok, handle = pcall(skynet.call, redis_mgr, "lua", "get_handle")
        if ok then
            redis_handle = handle
        end
    end
    local ok, result = pcall(skynet.call, redis_handle, "lua", cmd, uid, ...)
    if not ok then return {} end
    return result
end

