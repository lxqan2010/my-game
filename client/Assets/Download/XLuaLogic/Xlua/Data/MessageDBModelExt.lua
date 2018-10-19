--数据表扩展
require "Download/XLuaLogic/Xlua/Data/Create/MessageEntity"


MessageDBModelExt = {};
local this = MessageDBModelExt;


function MessageDBModelExt.New()
	return this;
end

--根据状态获取数据
function MessageDBModelExt.GetListByStatus(status)
	local taskTable = DBModelMgr.GetDBModel(DBModelNames.MessageDBModel).GetList();
	--要返回的表
	local retTable = {};
	for i=1,#taskTable,1 do
		if(taskTable[i].Status == status) then
			retTable[#retTable+1] = taskTable[i];
		end
	end
	
	return retTable;
end