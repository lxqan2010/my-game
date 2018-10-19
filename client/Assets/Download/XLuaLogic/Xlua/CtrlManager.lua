--Lua控制器的管理器 作用就是注册所有的控制器

print('启动CtrlManager.lua')

require "Download/XLuaLogic/Xlua/Common/Define"
require "Download/XLuaLogic/Xlua/GameCtrl/UIRootCtrl"
require "Download/XLuaLogic/Xlua/GameCtrl/MessageCtrl"

CtrlManager = {};
local this = CtrlManager;

--控制器列表
local ctrlList = {};

--初始化 往列表中添加所有的控制器
function CtrlManager.Init()
	ctrlList[CtrlNames.UIRootCtrl] = UIRootCtrl.New();
	ctrlList[CtrlNames.MessageCtrl] = MessageCtrl.New();
	return this;
end

--根据控制器的名称 获取控制器
function CtrlManager.GetCtrl(ctrlName)
	return ctrlList[ctrlName];
end