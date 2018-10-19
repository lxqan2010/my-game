require "Download/XLuaLogic/Xlua/GameView/MessageView"
require "Download/XLuaLogic/Xlua/Common/Define"
require "Download/XLuaLogic/Xlua/Data/DBModelMgr"

MessageCtrl = {};
local this = MessageCtrl;

local transform;
local gameObject;


function MessageCtrl.New()
	return this;
end

function MessageCtrl.Awake()	
	print('MessageCtrl.Awake');
	CS.LuaHelper._Instance.UIViewUtil:LoadWindowForLua("MessageView",this.OnCreate,"Download/UIPerfab/UIWindows/Pan_MessageView.assetbundle");

end

--启动事件--
function MessageCtrl.OnCreate(obj)
	--添加协议的监听
			
end

function MessageCtrl.OnStart()
	print("任务列表创建完毕");	
	--数据实体
	--拿出镜像
	CS.LuaHelper._Instance.AssetBundleMgr:LoadOrDownloadForLua("Download/UIPerfab/UIWindows/TaskItemView.assetbundle", "TaskItemView",this.OnLoadItem);

end


function MessageCtrl.OnLoadItem(obj)
	--这个obj就是镜像
	--定义列表
	local taskTable = DBModelMgr.GetDBModel(DBModelNames.MessageDBModelExt).GetListByStatus(0);
	
	for i=1,#taskTable,1 do
		--克隆预设
		local item = CS.UnityEngine.Object.Instantiate(obj);
		item.transform.parent = MessageView.content;
        item.transform.localPosition = Vector3.zero;
        item.transform.localScale = Vector3.one;
		
		--赋值
		local task = taskTable[i];
		
		local txtTitle = item.transform:Find("txtTitle"):GetComponent("UnityEngine.UI.Text");
		local txtStatus = item.transform:Find("txtStatus"):GetComponent("UnityEngine.UI.Text");
		txtTitle.text = task.Title;
		txtStatus.text = this.GetTaskStatusName(task.Status);
		
		local btnItem = item.transform:GetComponent("UnityEngine.UI.Button");   
		btnItem.onClick:AddListener(
			function ()
				MessageView.detailContainer.gameObject:SetActive(true);
				MessageView.txtTaskId.text = tostring(task.Id);
				MessageView.txtTaskName.text = task.Title;
				MessageView.txtTaskStatus.text = this.GetTaskStatusName(task.Status);
				MessageView.txtTaskContent:DOText(task.Content,0.5);
			end
		
		
		);
	end
end

function MessageCtrl.GetTaskStatusName(status)
	if(status == 0)then
		return "<color=#06C300FF>未接</color>"
	elseif(status == 1)then
		return "<color=#00CAFFFF>已接</color>"
	elseif(status == 2)then
		return "<color=#FFAE00FF>已完成</color>"
	end
end