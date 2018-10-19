using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XLua;

/// <summary>
/// xLua环境管理类
/// </summary>
public class LuaManager : SingletonMono<LuaManager>
{
    /// <summary>
    /// 全局的xLua引擎
    /// </summary>
    public static LuaEnv LuaEnv;


    protected override void OnAwake()
    {
        base.OnAwake();

        LuaEnv = new LuaEnv();
        //这里相当于初始化路径 也就是 Application.dataPath 文件夹下 .lua的文件都会被初始化加载
        LuaEnv.DoString(string.Format("package.path = '{0}/?.lua'", Application.dataPath));
    }


    /// <summary>
    /// 执行lua脚本
    /// </summary>
    /// <param name="str"></param>
    public void DoString(string str)
    {
        LuaEnv.DoString(str);      
    }



    protected override void OnUpdate()
    {
        base.OnUpdate();
        //luaEnv.GC(); //时刻回收
    }


    protected override void BeforeOnDestroy()
    {
        base.BeforeOnDestroy();
        //luaEnv.Dispose(); //释放
    }

}

