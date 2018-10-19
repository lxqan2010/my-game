-- 热更新上层逻辑
-- Created by IntelliJ IDEA.
-- User: wjb
-- Date: 17/3/10
-- Time: 下午3:23

local lfs = require "lfs"
local skynet = require "skynet"
local hotfix = require "hotfix"

local _hotfix_ex = {}

local game_path = ""
local sep = string.match (package.config, "[^\n]+")
local exclude_key = {
    "_G"
}

--更新虚拟机
local function process(path_time, key, first, update_list)
    local MOD_NAME = "game_hotfix.hotfix_file"
    if not package.searchpath(MOD_NAME, package.path) then
        return
    end
    package.loaded[MOD_NAME] = nil
    local h_file = require(MOD_NAME)
    --遍历要更新的文件
    for _, v in pairs(h_file[key]) do
        local flag, name = table.unpack(v)
        if flag == "d" then --文件夹
            local path = game_path..name
            for file in lfs.dir(path) do
                if file ~= "." and file ~= ".." then
                    local module_name
                    local pos = string.find(file, ".", 1, true)
                    if not pos then
                        module_name = file
                    else
                        if pos ~= 1 then
                            module_name = string.sub(file, 1, pos-1)
                            local file_path = package.searchpath(module_name, package.path)
                            if not file_path then
                                module_name = name.."."..module_name
                            end
                        end
                    end
                    if pos ~= 1 then
                        local f = path..sep..file
                        local file_time = lfs.attributes (f, "modification")
                        if file_time ~= path_time[module_name] then
                            hotfix.hotfix_module(module_name)
                            path_time[module_name] = file_time
                            --如果不是第一次更新
                            if not first then
                                logger_hotfix:debug("Hot fix module %s", f)
                                table.insert(update_list, {module_name, name})
                            end
                        end
                    end
                end
            end
        elseif flag == "f" or flag == "fc" then
            local module_name = name
            local path, err = package.searchpath(module_name, package.path)
            -- Skip non-exist module.
            if not path then
                logger_hotfix:error("No such module: %s. %s", module_name, err)
            else
                local file_time = lfs.attributes (path, "modification")
                if file_time ~= path_time[module_name] then
                    path_time[module_name] = file_time
                    if v[1] == "fc" then
                        hotfix.hotfix_module(module_name, true)
                    else
                        hotfix.hotfix_module(module_name)
                    end
                    --如果不是第一次更新
                    if not first then
                        logger_hotfix:debug("Hot fix module %s (%s)", module_name, path)
                        table.insert(update_list, {module_name})
                    end
                end
            end
        end
    end
end

--初始化
function _hotfix_ex.init(path_time)
    for k, v in pairs(_G) do
        if not table.member(exclude_key, k) then
            hotfix.add_one_protect(v)
        end
    end
    local node = skynet.getenv("nodename")
    if string.find(node ,"game", 1, true) then
        game_path = "./landlord/game/"
    elseif string.find(node, "login", 1, true) then
        game_path = "./landlord/login/"
    else
        game_path = "./landlord/clientlog/"
    end
    local MOD_NAME = "game_hotfix.hotfix_file"
    local h_file = require(MOD_NAME)
    local update_list = {}
    for k in pairs(h_file) do
        process(path_time, k, true, update_list)
    end
end

--更新
function _hotfix_ex.check(path_time)
    local MOD_NAME = "game_hotfix.hotfix_file"
    package.loaded[MOD_NAME] = nil
    local h_file = require(MOD_NAME)
    local update_list = {}
    for k in pairs(h_file) do
        process(path_time, k, false, update_list)
    end
    return update_list
end

--某一个更新
function _hotfix_ex.update_one(label, update_list)
    local MOD_NAME = "game_hotfix.hotfix_file"
    package.loaded[MOD_NAME] = nil
    local h_file = require(MOD_NAME)
    for _, v in ipairs(update_list) do
        local module_d_name = ""
        local module_name, d_name = table.unpack(v)
        local pos = string.find(module_name, '.', 1, true)
        if pos then
            module_d_name = string.sub(module_name, 1, pos-1)
        end
        --检查每个文件
        for _, f in ipairs(h_file[label]) do
            local flag, name = table.unpack(f)
            if flag == 'f' or flag == 'fc' then
                if name == module_name then
                    if flag == "fc" then
                        hotfix.hotfix_module(module_name, true)
                    else
                        hotfix.hotfix_module(module_name)
                    end
                end
            end
            --文件夹
            if flag == 'd' then
                if d_name then --有文件夹的名字
                    if name == d_name then
                        hotfix.hotfix_module(module_name)
                    end
                else
                    --说明文件夹需要遍历这个文件
                    if module_d_name == name then
                        hotfix.hotfix_module(module_name)
                    end
                end
            end
        end
    end
end

return _hotfix_ex