using System.Collections;
using System.Collections.Generic;
using UnityEngine;


/// <summary>
/// xLua入口
/// </summary>
public class GameManager : MonoBehaviour
{

    void Awake()
    {
        //启动的时候 在自身挂上 LuaManager 脚本
        gameObject.AddComponent<LuaManager>();
        DontDestroyOnLoad(gameObject);
    }

    void Start()
    {
        if (DelegateDefine._Instance.OnSceneLoadOK != null)
        {
            DelegateDefine._Instance.OnSceneLoadOK();
        }

        //执行lua Main脚本
        LuaManager.Instance.DoString("require'Download/XLuaLogic/Xlua/Main'");
        //创建窗体
        LuaHelper._Instance.LoadLuaView("UIRootCtrl"); 
    }
}

