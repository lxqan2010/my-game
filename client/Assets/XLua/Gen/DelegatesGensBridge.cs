﻿#if USE_UNI_LUA
using LuaAPI = UniLua.Lua;
using RealStatePtr = UniLua.ILuaState;
using LuaCSFunction = UniLua.CSharpFunctionDelegate;
#else
using LuaAPI = XLua.LuaDLL.Lua;
using RealStatePtr = System.IntPtr;
using LuaCSFunction = XLua.LuaDLL.lua_CSFunction;
#endif

using System;


namespace XLua
{
    public partial class DelegateBridge : DelegateBridgeBase
    {
		
		public void __Gen_Delegate_Imp0(byte[] p0)
		{
#if THREAD_SAFE || HOTFIX_ENABLE
            lock (luaEnv.luaEnvLock)
            {
#endif
                RealStatePtr L = luaEnv.rawL;
                int err_func =LuaAPI.load_error_func(L, errorFuncRef);
                
                
                LuaAPI.lua_getref(L, luaReference);
                
                LuaAPI.lua_pushstring(L, p0);
                
                int __gen_error = LuaAPI.lua_pcall(L, 1, 0, err_func);
                if (__gen_error != 0)
                    luaEnv.ThrowExceptionFromError(err_func - 1);
                
                
                
                LuaAPI.lua_settop(L, err_func - 1);
                
#if THREAD_SAFE || HOTFIX_ENABLE
            }
#endif
		}
        
		public void __Gen_Delegate_Imp1(string[] p0)
		{
#if THREAD_SAFE || HOTFIX_ENABLE
            lock (luaEnv.luaEnvLock)
            {
#endif
                RealStatePtr L = luaEnv.rawL;
                int err_func =LuaAPI.load_error_func(L, errorFuncRef);
                ObjectTranslator translator = luaEnv.translator;
                
                LuaAPI.lua_getref(L, luaReference);
                
                translator.Push(L, p0);
                
                int __gen_error = LuaAPI.lua_pcall(L, 1, 0, err_func);
                if (__gen_error != 0)
                    luaEnv.ThrowExceptionFromError(err_func - 1);
                
                
                
                LuaAPI.lua_settop(L, err_func - 1);
                
#if THREAD_SAFE || HOTFIX_ENABLE
            }
#endif
		}
        
		public void __Gen_Delegate_Imp2(UnityEngine.GameObject p0)
		{
#if THREAD_SAFE || HOTFIX_ENABLE
            lock (luaEnv.luaEnvLock)
            {
#endif
                RealStatePtr L = luaEnv.rawL;
                int err_func =LuaAPI.load_error_func(L, errorFuncRef);
                ObjectTranslator translator = luaEnv.translator;
                
                LuaAPI.lua_getref(L, luaReference);
                
                translator.Push(L, p0);
                
                int __gen_error = LuaAPI.lua_pcall(L, 1, 0, err_func);
                if (__gen_error != 0)
                    luaEnv.ThrowExceptionFromError(err_func - 1);
                
                
                
                LuaAPI.lua_settop(L, err_func - 1);
                
#if THREAD_SAFE || HOTFIX_ENABLE
            }
#endif
		}
        
		public void __Gen_Delegate_Imp3()
		{
#if THREAD_SAFE || HOTFIX_ENABLE
            lock (luaEnv.luaEnvLock)
            {
#endif
                RealStatePtr L = luaEnv.rawL;
                int err_func =LuaAPI.load_error_func(L, errorFuncRef);
                
                
                LuaAPI.lua_getref(L, luaReference);
                
                
                int __gen_error = LuaAPI.lua_pcall(L, 0, 0, err_func);
                if (__gen_error != 0)
                    luaEnv.ThrowExceptionFromError(err_func - 1);
                
                
                
                LuaAPI.lua_settop(L, err_func - 1);
                
#if THREAD_SAFE || HOTFIX_ENABLE
            }
#endif
		}
        
		public void __Gen_Delegate_Imp4(string p0)
		{
#if THREAD_SAFE || HOTFIX_ENABLE
            lock (luaEnv.luaEnvLock)
            {
#endif
                RealStatePtr L = luaEnv.rawL;
                int err_func =LuaAPI.load_error_func(L, errorFuncRef);
                
                
                LuaAPI.lua_getref(L, luaReference);
                
                LuaAPI.lua_pushstring(L, p0);
                
                int __gen_error = LuaAPI.lua_pcall(L, 1, 0, err_func);
                if (__gen_error != 0)
                    luaEnv.ThrowExceptionFromError(err_func - 1);
                
                
                
                LuaAPI.lua_settop(L, err_func - 1);
                
#if THREAD_SAFE || HOTFIX_ENABLE
            }
#endif
		}
        
		public double __Gen_Delegate_Imp5(double p0, double p1)
		{
#if THREAD_SAFE || HOTFIX_ENABLE
            lock (luaEnv.luaEnvLock)
            {
#endif
                RealStatePtr L = luaEnv.rawL;
                int err_func =LuaAPI.load_error_func(L, errorFuncRef);
                
                
                LuaAPI.lua_getref(L, luaReference);
                
                LuaAPI.lua_pushnumber(L, p0);
                LuaAPI.lua_pushnumber(L, p1);
                
                int __gen_error = LuaAPI.lua_pcall(L, 2, 1, err_func);
                if (__gen_error != 0)
                    luaEnv.ThrowExceptionFromError(err_func - 1);
                
                
                double __gen_ret = LuaAPI.lua_tonumber(L, err_func + 1);
                LuaAPI.lua_settop(L, err_func - 1);
                return  __gen_ret;
#if THREAD_SAFE || HOTFIX_ENABLE
            }
#endif
		}
        
		public void __Gen_Delegate_Imp6(double p0)
		{
#if THREAD_SAFE || HOTFIX_ENABLE
            lock (luaEnv.luaEnvLock)
            {
#endif
                RealStatePtr L = luaEnv.rawL;
                int err_func =LuaAPI.load_error_func(L, errorFuncRef);
                
                
                LuaAPI.lua_getref(L, luaReference);
                
                LuaAPI.lua_pushnumber(L, p0);
                
                int __gen_error = LuaAPI.lua_pcall(L, 1, 0, err_func);
                if (__gen_error != 0)
                    luaEnv.ThrowExceptionFromError(err_func - 1);
                
                
                
                LuaAPI.lua_settop(L, err_func - 1);
                
#if THREAD_SAFE || HOTFIX_ENABLE
            }
#endif
		}
        
		public int __Gen_Delegate_Imp7(int p0, string p1, out CSCallLua.DClass p2)
		{
#if THREAD_SAFE || HOTFIX_ENABLE
            lock (luaEnv.luaEnvLock)
            {
#endif
                RealStatePtr L = luaEnv.rawL;
                int err_func =LuaAPI.load_error_func(L, errorFuncRef);
                ObjectTranslator translator = luaEnv.translator;
                
                LuaAPI.lua_getref(L, luaReference);
                
                LuaAPI.xlua_pushinteger(L, p0);
                LuaAPI.lua_pushstring(L, p1);
                
                int __gen_error = LuaAPI.lua_pcall(L, 2, 2, err_func);
                if (__gen_error != 0)
                    luaEnv.ThrowExceptionFromError(err_func - 1);
                
                p2 = (CSCallLua.DClass)translator.GetObject(L, err_func + 2, typeof(CSCallLua.DClass));
                
                int __gen_ret = LuaAPI.xlua_tointeger(L, err_func + 1);
                LuaAPI.lua_settop(L, err_func - 1);
                return  __gen_ret;
#if THREAD_SAFE || HOTFIX_ENABLE
            }
#endif
		}
        
		public System.Action __Gen_Delegate_Imp8()
		{
#if THREAD_SAFE || HOTFIX_ENABLE
            lock (luaEnv.luaEnvLock)
            {
#endif
                RealStatePtr L = luaEnv.rawL;
                int err_func =LuaAPI.load_error_func(L, errorFuncRef);
                ObjectTranslator translator = luaEnv.translator;
                
                LuaAPI.lua_getref(L, luaReference);
                
                
                int __gen_error = LuaAPI.lua_pcall(L, 0, 1, err_func);
                if (__gen_error != 0)
                    luaEnv.ThrowExceptionFromError(err_func - 1);
                
                
                System.Action __gen_ret = translator.GetDelegate<System.Action>(L, err_func + 1);
                LuaAPI.lua_settop(L, err_func - 1);
                return  __gen_ret;
#if THREAD_SAFE || HOTFIX_ENABLE
            }
#endif
		}
        
        
		static DelegateBridge()
		{
		    Gen_Flag = true;
		}
		
		public override Delegate GetDelegateByType(Type type)
		{
		
		    if (type == typeof(SocketDispatcher.OnActionHandler))
			{
			    return new SocketDispatcher.OnActionHandler(__Gen_Delegate_Imp0);
			}
		
		    if (type == typeof(UIDispatcher.OnActionHandler))
			{
			    return new UIDispatcher.OnActionHandler(__Gen_Delegate_Imp1);
			}
		
		    if (type == typeof(LuaViewBehaviour.delLuaAwake))
			{
			    return new LuaViewBehaviour.delLuaAwake(__Gen_Delegate_Imp2);
			}
		
		    if (type == typeof(LuaWindowBehaviour.delLuaAwake))
			{
			    return new LuaWindowBehaviour.delLuaAwake(__Gen_Delegate_Imp2);
			}
		
		    if (type == typeof(XLuaCustomExport.OnCreate))
			{
			    return new XLuaCustomExport.OnCreate(__Gen_Delegate_Imp2);
			}
		
		    if (type == typeof(LuaViewBehaviour.delLuaStart))
			{
			    return new LuaViewBehaviour.delLuaStart(__Gen_Delegate_Imp3);
			}
		
		    if (type == typeof(LuaViewBehaviour.delLuaUpdate))
			{
			    return new LuaViewBehaviour.delLuaUpdate(__Gen_Delegate_Imp3);
			}
		
		    if (type == typeof(LuaViewBehaviour.delLuaOnDestroy))
			{
			    return new LuaViewBehaviour.delLuaOnDestroy(__Gen_Delegate_Imp3);
			}
		
		    if (type == typeof(LuaWindowBehaviour.delLuaStart))
			{
			    return new LuaWindowBehaviour.delLuaStart(__Gen_Delegate_Imp3);
			}
		
		    if (type == typeof(LuaWindowBehaviour.delLuaUpdate))
			{
			    return new LuaWindowBehaviour.delLuaUpdate(__Gen_Delegate_Imp3);
			}
		
		    if (type == typeof(LuaWindowBehaviour.delLuaOnDestroy))
			{
			    return new LuaWindowBehaviour.delLuaOnDestroy(__Gen_Delegate_Imp3);
			}
		
		    if (type == typeof(System.Action))
			{
			    return new System.Action(__Gen_Delegate_Imp3);
			}
		
		    if (type == typeof(UnityEngine.Events.UnityAction))
			{
			    return new UnityEngine.Events.UnityAction(__Gen_Delegate_Imp3);
			}
		
		    if (type == typeof(LuaHelper.delLuaLoadView))
			{
			    return new LuaHelper.delLuaLoadView(__Gen_Delegate_Imp4);
			}
		
		    if (type == typeof(System.Action<string>))
			{
			    return new System.Action<string>(__Gen_Delegate_Imp4);
			}
		
		    if (type == typeof(System.Func<double, double, double>))
			{
			    return new System.Func<double, double, double>(__Gen_Delegate_Imp5);
			}
		
		    if (type == typeof(System.Action<double>))
			{
			    return new System.Action<double>(__Gen_Delegate_Imp6);
			}
		
		    if (type == typeof(CSCallLua.FDelegate))
			{
			    return new CSCallLua.FDelegate(__Gen_Delegate_Imp7);
			}
		
		    if (type == typeof(CSCallLua.GetE))
			{
			    return new CSCallLua.GetE(__Gen_Delegate_Imp8);
			}
		
		    return null;
		}
	}
    
}