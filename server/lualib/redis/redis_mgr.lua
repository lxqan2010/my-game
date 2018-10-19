-- redis相关接口
-- Created by IntelliJ IDEA.
-- User: wjb
-- Date: 16/10/9
-- Time: 下午5:03

local command = {}
local connect_num = 10
local redis = require "skynet.db.redis"
local config = require "redis_config"

--获取某一个redis连接
local function get_conn(conn_list, index)
    local db = conn_list[1];
    if index > connect_num then
        index = 1
    end

    return conn_list[index], index + 1
end

--获取连接
local function get_pool_conn(pool)
    local old_index = pool.index
    local db = pool.conn[old_index]
    if old_index + 1 > connect_num then
        pool.index = 1
    else
        pool.index = old_index + 1
    end
    return db, old_index
end

--增加容错调用
local function call_query(pool, index, db, cmd, key, ...)
    local ok, result = pcall(db[cmd], db, key, ...)
    if not ok then
        --logger_redis:error("redis %d query key %s error %s, cmd %s", index, key, result, cmd)
        --底层可能释放掉了，这里再做一个调用
        if db.disconnect then
            db:disconnect()
        end
        local cf = config[1]
        local ok , new_db = pcall(redis.connect, cf)
        if not ok then
			logger_redis:error("redis connect %s:%d error, %s", cf.host, cf.port, new_db)
            return
        else
            pool[index] = new_db
        end
        ok, result = pcall(new_db[cmd], new_db, key, ...)
        if not ok then
            logger_redis:error("redis %d query key %s error %s, cmd %s", index, key, result, cmd)
            return
        end
    end
    return result
end

--初始化
function command.start(pool)
	local cf = config[1]
	for i = 1, connect_num do --初始化,每个生成connect_num个连接
		local ok , result = pcall(redis.connect, cf)
		if not ok then
			logger_redis:error("redis connect %s:%d error, %s", cf.host, cf.port, result)
		else
			table.insert(pool.conn, result)
		end
	end
end

function command.set(pool, uid, key, value)
	local db, old_index = get_pool_conn(pool, uid)
    local result = call_query(pool, old_index, db, "set", key, value)
	return result
end

function command.get(pool, uid, key)
	local db, old_index = get_pool_conn(pool, uid)
    local result = call_query(pool, old_index, db, "get", key)
	return result
end

--hash设置多个键值
function command.hmset(pool, uid, key, ...)
	local db, old_index = get_pool_conn(pool, uid)
    local result = call_query(pool, old_index, db, "hmset", key, ...)
	return result
end

--hash获取多个键值
function command.hmget(pool, uid, key, ...)
	if not key then return end

	local db, old_index = get_pool_conn(pool, uid)
    local result = call_query(pool, old_index, db, "hmget", key, ...)

	return result
end

--hash设置某一个键值
function command.hset(pool, uid, key, filed, value)
	local db, old_index = get_pool_conn(pool, uid)
    local result = call_query(pool, old_index, db, "hset", key, filed, value)

	return result
end

--hash获取某个键值
function command.hget(pool, uid, key, filed)
	local db, old_index = get_pool_conn(pool, uid)
    local result = call_query(pool, old_index, db, "hget", key, filed)

	return result
end

--hash获取某个键所有值
function command.hgetall(pool, uid, key)
	local db, old_index = get_pool_conn(pool, uid)
    local result = call_query(pool, old_index, db, "hgetall", key)

	return result
end

--hash递增某个键值的值
function command.hincrby(pool, uid, key, field, val)
	local db, old_index = get_pool_conn(pool, uid)
    local result = call_query(pool, old_index, db, "hincrby", key, field, val)

	return result
end

--hash删除某个键值
function command.hdel(pool, uid, key, field)
	local db, old_index = get_pool_conn(pool, uid)
    local result = call_query(pool, old_index, db, "hdel", key, field)

	return result
end

--hash获取所有键值
function command.hkeys(pool, uid, key)
	local db, old_index = get_pool_conn(pool, uid)
    local result = call_query(pool, old_index, db, "hkeys", key)

	return result
end

function command.zadd(pool, uid, key, score, member)
	local db, old_index = get_pool_conn(pool,uid)
    local result = call_query(pool, old_index, db, "zadd", key, score, member)

	return result
end

function command.zrange(pool, uid, key, from, to)
	local db, old_index = get_pool_conn(pool, uid)
    local result = call_query(pool, old_index, db, "zrange", key, from, to)

	return result
end

function command.zrevrange(pool, uid, key, from, to ,scores)
	local result
	local db, old_index = get_pool_conn(pool,uid)
	if not scores then
        result = call_query(pool, old_index, db, "zrevrange", key, from, to)
	else
        result = call_query(pool, old_index, db, "zrevrange", key, from, to, scores)
	end

	return result
end

function command.zrank(pool, uid, key, member)
	local db, old_index = get_pool_conn(pool, uid)
    local result = call_query(pool, old_index, db, "zrank", key, member)

	return result
end

function command.zrevrank(pool, uid, key, member)
	local db,old_index = get_pool_conn(pool, uid)
    local result = call_query(pool, old_index, db, "zrevrank", key, member)

	return result
end

function command.zscore(pool, uid, key, score)
	local db, old_index = get_pool_conn(pool, uid)
    local result = call_query(pool, old_index, db, "zscore", key, score)

	return result
end

function command.zcount(pool, uid, key, from, to)
	local db, old_index= get_pool_conn(pool, uid)
    local result = call_query(pool, old_index, db, "zcount", key, from, to)

	return result
end

function command.zcard(pool, uid, key)
    local db, old_index= get_pool_conn(pool, uid)
    local result = call_query(pool, old_index, db, "zcard", key)

	return result
end

function command.incr(pool, uid, key)
    local db, old_index= get_pool_conn(pool, uid)
    local result = call_query(pool, old_index, db, "incr", key)

	return result
end

function command.del(pool, uid, key)
    local db, old_index= get_pool_conn(pool, uid)
    local result = call_query(pool, old_index, db, "del", key)

	return result
end

--检测某个键值是否存在
function command.exists(pool, uid, key)
    local db, old_index= get_pool_conn(pool, uid)
    local result = call_query(pool, old_index, db, "exists", key)

	if result then
		return true
	end
	return false
end

--增加某个键值
function command.incrby(pool, uid, key, val)
    local db, old_index= get_pool_conn(pool, uid)
    local result = call_query(pool, old_index, db, "incrby", key, val)

	return result
end

--集合个数
function command.scard(pool, uid, key)
    local db, old_index= get_pool_conn(pool, uid)
    local result = call_query(pool, old_index, db, "scard", key)

	return result
end

--集合增加元素
function command.sadd(pool, uid, key, val)
    local db, old_index= get_pool_conn(pool, uid)
    local result = call_query(pool, old_index, db, "sadd", key, val)

	return result
end

--获取集合所有元素
function command.smembers(pool, uid, key)
    local db, old_index= get_pool_conn(pool, uid)
    local result = call_query(pool, old_index, db, "smembers", key)

	return result
end

--删除集合元素
function command.srem(pool, uid, key, val)
    local db, old_index= get_pool_conn(pool, uid)
    local result = call_query(pool, old_index, db, "srem", key, val)

	return result
end

--列表范围
function command.lrange(pool, uid, key, start_index, end_index)
    local db, old_index= get_pool_conn(pool, uid)
    local result = call_query(pool, old_index, db, "lrange", key, start_index, end_index)

	return result
end

--列表元素移除
function command.lrem(pool, uid, key, count, val)
    local db, old_index= get_pool_conn(pool, uid)
    local result = call_query(pool, old_index, db, "lrem", key, count, val)

	return result
end

--列表元素插入表尾
function command.rpush(pool, uid, key, val)
    local db, old_index= get_pool_conn(pool, uid)
    local result = call_query(pool, old_index, db, "rpush", key, val)

	return result
end

--列表元素插入表头
function command.lpush(pool, uid, key, val)
    local db, old_index= get_pool_conn(pool, uid)
    local result = call_query(pool, old_index, db, "lpush", key, val)

	return result
end

--长度
function command.llen(pool, uid, key)
    local db, old_index= get_pool_conn(pool, uid)
    local result = call_query(pool, old_index, db, "llen", key)

	return result
end

--超时设置
function command.expire(pool, uid, key, val)
    local db, old_index= get_pool_conn(pool, uid)
    local result = call_query(pool, old_index, db, "expire", key, val)

	return result
end

--获取某个key列表
function command.keys(pool, uid, key)
    local db, old_index = get_pool_conn(pool, uid)
    local result = call_query(pool, old_index, db, "keys", key)

    return result
end

return command