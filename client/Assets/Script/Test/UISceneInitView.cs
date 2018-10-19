﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

/// <summary>
/// 初始化场景UI
/// </summary>
public class UISceneInitView : MonoBehaviour {

    [SerializeField]
    private Text txt_Load;

    [SerializeField]
    private Slider slider_Load;

    public static UISceneInitView Instance;


    void Awake()
    {
        Instance = this;
    }


    /// <summary>
    /// 设置进度条的值
    /// </summary>
    /// <param name="text"></param>
    /// <param name="value"></param>
    public void SetProgress(string text, float value)
    {
        txt_Load.text = text;
        slider_Load.value = value;
    }
}
