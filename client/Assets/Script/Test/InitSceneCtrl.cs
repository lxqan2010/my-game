﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;


/// <summary>
/// 初始化场景管理
/// </summary>
public class InitSceneCtrl : MonoBehaviour {

    void Start()
    {
#if DISABLE_ASSETBUNDLE
        SceneMgr._Instance.LoadToLogOn();
#else
        //获取服务器下发的资源服务器地址
        //DownloadMgr.DownLoadBaseUrl = GlobalInit.Instance.CurrChannelInitConfig.SourceUrl;
        //启动协程
        DownloadMgr._Instance.InitStreamingAssets(OnInitComplete);
#endif
    }

    void OnInitComplete()
    {
        //启动协程
        StartCoroutine(LoadLogOn());
    }


    /// <summary>
    /// 加载登陆场景
    /// </summary>
    /// <returns></returns>
    private IEnumerator LoadLogOn()
    {
        yield return new WaitForSeconds(0.3f);
        SceneMgr._Instance.LoadToLogOn();

    }
}
