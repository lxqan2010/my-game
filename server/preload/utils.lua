local cjson = require "cjson"
local skynet = require "skynet"
local const = require "lib_constant"

function cjson_encode(obj)
	return cjson.encode(obj)
end

function cjson_decode(json)
	return cjson.decode(json)
end

function cjson_table(val)
    if not val then
        return {}
    end
    return cjson_decode(val)
end

--创建定时器
function create_timeout(ti, func)
    local active = true
    local function cb()
        if active then
            func()
            func = nil
        end
    end
    skynet.timeout(ti, cb)
    return function() active, func = false, nil end
end

--根据权重筛选
function key_rand(obj, key)
    if #obj == 0 then
        return
    end

    local weight = {}
    local t = 0
    for k, v in ipairs(obj) do
        t = t + v[key]
        weight[k] = t
    end
    if t <= 0 then
        return math.random(1, #weight)
    end
    local c = math.random(1, t)
    for k, v in ipairs(weight) do
        if c <= v then
            return k
        end
    end
    return #weight
end

--初始化为默认值
function init_inc(old_val,default_val,inc_val)
    if not old_val then
        old_val = default_val
    end
    return old_val + inc_val
end

--两者取较大值
function max(val1,val2)
    if val1>val2 then
        return val1
    end
    return val2
end

--两者取最小值
function min(val1, val2)
    if val1 < val2 then
        return val1
    end
    return val2
end

--列表转为发送数据
function empty_to_data(t)
    if not t or table.empty(t) then
        return nil
    end
    return t
end

--列表随机一个值
function list_rand(obj)
    if not obj or #obj == 0 then
        return
    end
    local index = math.random(1, #obj)
    return obj[index]
end

--true 转换为int
function if_true_int(ret)
    if ret then
        return 1
    end
    return 0
end

--将字符串转换为bool
function string_to_bool(str)
    if str == "true" then
        return true
    end
    return false
end

--时间相关-------
--时间戳,秒
function skynet_time()
	return os.time()
end

--获取今天是哪一天
function date_day()
    local t_date = os.date("*t")
    return t_date.day
end

--获取当天0点时间戳
function unixtime_today()
    local t_date = os.date("*t")
    return os.time({
        year = t_date.year,
        month = t_date.month,
        day = t_date.day,
        hour = 0,
        min = 0,
        sec = 0
    })
end

--获取当天指定时刻时间戳， h:m:s
function unixtime_time(str)
    local arr = string.split(str,":")
    local t_date = os.date("*t")
    return os.time({
        year = t_date.year,
        month = t_date.month,
        day = t_date.day,
        hour = tonumber(arr[1]),
        min = tonumber(arr[2]),
        sec = tonumber(arr[3])
    })
end

--获取明天0点时间戳
function unixtime_tomorrow()
    return unixtime_today() + const.DAY_SEC
end

--获取星期
function week_num()
    local t_date = os.date("*t")
    if t_date.wday == 1 then
        return 7
    end
    return t_date.wday -1
end

--获取星期一时间戳
function unixtime_monday()
    return unixtime_today()- const.DAY_SEC*(week_num()-1)
end

--获取下周一时间戳
function unixtime_next_monday()
    return unixtime_today() + const.DAY_SEC*(8-week_num())
end

--获取下个月1号的时间戳
function get_month_one()
    local t_date = os.date("*t")
    local month = t_date.month + 1
    local year = t_date.year
    if month >12 then
        month = 1
        year = year + 1
    end
    return os.time({
        year = year,
        month = month,
        day = 1,
        hour = 0,
        min = 0,
        sec = 0
    })
end

--获取昨天的日期
function get_yesterday_date()
    local today_time = unixtime_today()
    return os.date("%Y-%m-%d", today_time-10)
end

--获取某个自定义时间戳
function unixtime_hms(hour, min, sec)
    return unixtime_today() + hour*60*60 + min*60 + sec
end

--获取某时间戳的0点时间
function unixtime_zero_time(unix_time)
    local t_date = os.date("*t", unix_time)
    return os.time({
        year = t_date.year,
        month = t_date.month,
        day = t_date.day,
        hour = 0,
        min = 0,
        sec = 0
    })
end

--获取下一个h,m,s时间
function unixtime_next_hms(hour, min, sec)
    local ts = unixtime_hms(hour, min, sec)
    local now = skynet_time()
    if now < ts then
        return ts
    else
        return ts + const.DAY_SEC
    end
end

--diff时间
function unixtime_diff(hour, min ,sec)
    local UT1 = unixtime_next_hms(hour, min, sec)
    local UT2 = skynet_time()
    return UT1 - UT2
end

--检查两个时间是否同一天
function unixtime_is_same(time1, time2)
    local t_date_1 = os.date("*t", time1)
    local t_date_2 = os.date("*t", time2)
    return t_date_1.year == t_date_2.year and t_date_1.month == t_date_2.month
            and t_date_1.day == t_date_2.day
end

--获取字符串时间戳
--time_str = "2016-7-18 0:0:0
function get_str_time(time_str)
    local time_str = string.split(time_str," ")
    local time_date = string.split(time_str[1], "-")
    local time_time = string.split(time_str[2],":")
    return os.time({
        year = tonumber(time_date[1]),
        month = tonumber(time_date[2]),
        day = tonumber(time_date[3]),
        hour = tonumber(time_time[1]),
        min = tonumber(time_time[2]),
        sec = tonumber(time_time[3])
    })
end

-- 检查格式2017-07-01和2017-7-1是否同一天
function date_is_same(date1, date2)
    local time_date1 = string.split(date1, "-")
    local time_date2 = string.split(date2, "-")

    return tonumber(time_date1[1]) == tonumber(time_date2[1]) and tonumber(time_date1[2]) == tonumber(time_date2[2]) and tonumber(time_date1[3]) == tonumber(time_date2[3])
end

-- 查找两个日期之间的所有日期
-- date2必须大于等于date1
function foreach_day(date1, date2, f)
    local date = date1
    local t = get_str_time(date .. " 0:0:0")
    while true do
        f(date)

        if date_is_same(date, date2) then
            break
        end
        t = t + 24 * 3600
        date = os.date("%Y-%m-%d", t)
    end
end

--检查sql注入
function check_sql_str(str)
    if not str or str == "" then
        return false
    end
    local str1 = string.lower(str)
    local str_list = {';', 'and','exec', 'insert','select', 'delete','update','count','master','truncate','declare','char(','mid(','chr(','\''}
    for _, v in ipairs(str_list) do
        local pos = string.find(str1, v, 1 , true)
        if pos then
            return true
        end
    end
    return false
end

-- 检查用户所属城市是否屏蔽城市
function check_city(city_config, city )
    if city_config and city then
        for _,v in ipairs(city_config) do
            local i = string.find(city, v)
            if i then
                return true
            end
        end
        return false
    end

    return true
end

-- 检查用户渠道是否开放红包功能
function check_channel(channel_config, channel)
    return not channel_config or
        (channel_config.type == 1 and table.include(channel_config.channel, channel)) or
        (channel_config.type == 2 and not table.include(channel_config.channel, channel))
end

-- 获取当前天数（自1970年）
function get_yday(timestamp)
    return math.floor((timestamp + (8 * 3600)) / (3600 * 24))
end


local function split(s, p)
    local rt = {}
    string.gsub(
        s,
        "[^" .. p .. "]+",
        function(w)
            table.insert(rt, w)
        end
    )
    return rt
end

local function version_to_number(version)
    if not version or version == "" then
        return 0
    end

    local arr = split(version, "%.")
    return tonumber(arr[1]) * 100 + tonumber(arr[2])
end

-- 检查版本是否大于等于指定版本号
function greater_version(version, user_version)
    return version_to_number(user_version) >= version_to_number(version)
end

-- 检查版本是否小于等于指定版本号
function less_version(version, user_version)
    return version_to_number(user_version) <= version_to_number(version)
end

