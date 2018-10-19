﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;



/// <summary>
/// UI窗口管理类
/// </summary>
public class UIViewMgr : Singleton<UIViewMgr>
{
    
    /// <summary>
    /// 存放UI窗体类型控制器的字典
    /// </summary>
    private Dictionary<WindowUIType, ISystemCtrl> m_SystenCtrlDic = new Dictionary<WindowUIType, ISystemCtrl>();



    /// <summary>
    /// 构造函数
    /// </summary>
    public UIViewMgr()
    {
        //m_SystenCtrlDic.Add(WindowUIType.LogOn, AccountCtrl.Instance);
        //m_SystenCtrlDic.Add(WindowUIType.Reg, AccountCtrl.Instance);

        //m_SystenCtrlDic.Add(WindowUIType.GameServerEnter, GameServerCtrl.Instance);
        //m_SystenCtrlDic.Add(WindowUIType.GameServerSelect, GameServerCtrl.Instance);

        //m_SystenCtrlDic.Add(WindowUIType.RoleInfo, PlayerCtrl.Instance);

        //m_SystenCtrlDic.Add(WindowUIType.GameLevelMap, GameLevelCtrl.Instance);
        //m_SystenCtrlDic.Add(WindowUIType.GameLevelDetail, GameLevelCtrl.Instance);
    }



    /// <summary>
    /// 打开UI视图
    /// </summary>
    /// <param name="type">窗口类型</param>
    public void OpenWindow(WindowUIType type)
    {
        m_SystenCtrlDic[type].OpenView(type);

    }

	
}

