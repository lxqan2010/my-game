-- 随机函数接口
-- Created by IntelliJ IDEA.
-- User: wjb
-- Date: 16/10/17
-- Time: 上午10:33

local command = {}

-- 此函数用法等价于math.random
-- command.Get(m,n)
do
    local randomtable
    local tablesize = 97

    function command.get(m, n)
        -- 初始化随机数与随机数表，生成97个[0,1)的随机数
        if not randomtable then
            -- 避免种子过小
            math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
            randomtable = {}
            for i = 1, tablesize do
                randomtable[i] = math.random()
            end
        end

        local x = math.random()
        local i = 1 + math.floor(tablesize*x)	-- i取值范围[1,97]
        x, randomtable[i] = randomtable[i], x	-- 取x为随机数，同时保证randomtable的动态性

        if not m then
            return x
        elseif not n then
            n = m
            m = 1
        end

        --if not Check(m <= n) then return end

        local offset = x*(n-m+1)
        return m + math.floor(offset)
    end
end

-- 取得[m, n]连续范围内的k个不重复的随机数
function command.get_range(m, n, k)

    --if not Check(m <= n) then return end
    --if not Check(k <= m-n+1) then return end

    local t = {}
    for i = m, n do
        t[#t + 1] = i
    end

    local size = #t
    for i = 1, k do
        local x = math.random(i, size)
        t[i], t[x] = t[x], t[i]		-- t[i]与t[x]交换
    end

    local result = {}
    for i = 1, k do
        result[#result + 1] = t[i]
    end

    return result
end

return command
