using UnityEngine;
using System.Collections;
using System;


/// <summary>
/// µ¥ÀýÀà
/// </summary>
/// <typeparam name="T">·ºÐÍ</typeparam>
public class Singleton<T> : IDisposable where T :new()
{
    private static T instance;

    public static T _Instance
    {
        get
        {
            if (instance == null)
            {
                instance = new T();
            }
            return instance;
        }
    }

    public virtual void Dispose()
    {
        
    }
}