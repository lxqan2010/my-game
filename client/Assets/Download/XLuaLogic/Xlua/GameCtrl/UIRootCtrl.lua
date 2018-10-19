--UIRoot控制器
require "Download/XLuaLogic/Xlua/GameView/UIRootView"

UIRootCtrl = {};
local this = UIRootCtrl;

local root;
local transform;
local gameObject;


function UIRootCtrl.New()
	return this;
end

function UIRootCtrl.Awake()
	
	print('主界面 启动了');
	--克隆UIRoot
	CS.LuaHelper._Instance.UISceneCtrl:LoadSceneUI(1,"Download/UIPerfab/UISceneView/UIRootView",this.OnCreate);

end

--启动事件--
function UIRootCtrl.OnCreate(obj)
	print("进入了回调");
	
	local btnOpenMessage = UIRootView.btnOpenMessage;
	btnOpenMessage.onClick:AddListener(this.OpenMessageClick);

	
end

--单击事件--
function UIRootCtrl.OpenMessageClick()
	
	print("点击了打开消息按钮");	
	GameInit.LoadView(CtrlNames.MessageCtrl);
end