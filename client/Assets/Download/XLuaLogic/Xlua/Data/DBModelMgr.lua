require "Download/XLuaLogic/Xlua/Common/Define"
require "Download/XLuaLogic/Xlua/Data/Create/MessageDBModel"
require "Download/XLuaLogic/Xlua/Data/MessageDBModelExt"

DBModelMgr = {};
local this = DBModelMgr;

--控制器列表
local DBModelList = {};

--初始化数据管理器
function DBModelMgr.Init()
	DBModelList[DBModelNames.MessageDBModel] = MessageDBModel.New();
	DBModelList[DBModelNames.MessageDBModel].Init();
	
	DBModelList[DBModelNames.MessageDBModelExt] = MessageDBModelExt.New();
	return this;
end

--根据控制器的名称 获取控制器
function DBModelMgr.GetDBModel(DBModelName)
	return DBModelList[DBModelName];
end