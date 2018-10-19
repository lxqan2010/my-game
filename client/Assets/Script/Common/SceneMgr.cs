using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;


/// <summary>
/// 场景跳转管理
/// </summary>
public class SceneMgr : Singleton<SceneMgr>
{
    /// <summary>
    /// 当前场景类型
    /// </summary>
    public SceneType CurrentSceneType { get; private set; }

    /// <summary>
    /// 当前玩法类型
    /// </summary>
    public PlayType CurrPlayType
    {
        get;
        private set;
    }


    public SceneMgr()
    {
        //服务器返回角色进入世界地图场景消息
        
    }

    
    /// <summary>
    /// 去登陆场景
    /// </summary>
    public void LoadToLogOn()
    {
        CurrentSceneType = SceneType.LogOn;
        SceneManager.LoadScene("Loading");
    }


    public override void Dispose()
    {
        base.Dispose();
       
    }
}
