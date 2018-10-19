using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;


/// <summary>
/// 所有窗口UI基类
/// </summary>
public class UIWindowViewBase : UIViewBase
{

    /// <summary>
    /// 挂点类型
    /// </summary>
    [SerializeField]
    public WindowUIContainerType containerType = WindowUIContainerType.Center;

    
    /// <summary>
    /// 打开方式
    /// </summary>
    [SerializeField]
    public WindowShowStyle showStyle = WindowShowStyle.Normal;


    /// <summary>
    /// 打开或关闭动画效果持续时间
    /// </summary>
    [SerializeField]
    public float duration = 0.2f;

    /// <summary>
    /// 视图的名称
    /// </summary>
    [HideInInspector]
    public string ViewName;

    /// <summary>
    /// 下一个要打开的窗口
    /// </summary>
    private WindowUIType m_NextOpenType;






    /// <summary>
    /// 按钮点击
    /// </summary>
    /// <param name="go"></param>
    protected override void OnBtnClick(GameObject go)
    {
        base.OnBtnClick(go);
        if (go.name.Equals("btnClose", StringComparison.CurrentCultureIgnoreCase))
        {
            Close();
        }
    }

    /// <summary>
    /// 关闭窗口
    /// </summary>
    public virtual void Close()
    {
        UIViewUtil._Instance.CloseWindow(ViewName);
    }

    /// <summary>
    /// 关闭并且打开下一个窗口
    /// </summary>
    /// <param name="nextType"></param>
    public virtual void CloseAndOpenNext(WindowUIType nextType)
    {
        this.Close();
        m_NextOpenType = nextType;
    }

    /// <summary>
    /// 销毁之前执行
    /// </summary>
    protected override void BeforeOnDestroy()
    {
       LayerUIMgr._Instance.CheckOpenWindow();

        if (m_NextOpenType != WindowUIType.None)
        {
            UIViewMgr._Instance.OpenWindow(m_NextOpenType);
        }

    }

}

