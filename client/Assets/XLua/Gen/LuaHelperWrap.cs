﻿#if USE_UNI_LUA
using LuaAPI = UniLua.Lua;
using RealStatePtr = UniLua.ILuaState;
using LuaCSFunction = UniLua.CSharpFunctionDelegate;
#else
using LuaAPI = XLua.LuaDLL.Lua;
using RealStatePtr = System.IntPtr;
using LuaCSFunction = XLua.LuaDLL.lua_CSFunction;
#endif

using XLua;
using System.Collections.Generic;


namespace XLua.CSObjectWrap
{
    using Utils = XLua.Utils;
    public class LuaHelperWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(LuaHelper);
			Utils.BeginObjectRegister(type, L, translator, 0, 7, 3, 0);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetData", _m_GetData);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "CreateMemoryStream", _m_CreateMemoryStream);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SendProto", _m_SendProto);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AddEventListtener", _m_AddEventListtener);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RemoveEventListener", _m_RemoveEventListener);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "LoadLuaView", _m_LoadLuaView);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AutoLoadTexture", _m_AutoLoadTexture);
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "UISceneCtrl", _g_get_UISceneCtrl);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "UIViewUtil", _g_get_UIViewUtil);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "AssetBundleMgr", _g_get_AssetBundleMgr);
            
			
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 1, 0, 0);
			
			
            
			
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					LuaHelper gen_ret = new LuaHelper();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to LuaHelper constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetData(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                LuaHelper gen_to_be_invoked = (LuaHelper)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _path = LuaAPI.lua_tostring(L, 2);
                    
                        GameDataTableToLua gen_ret = gen_to_be_invoked.GetData( _path );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CreateMemoryStream(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                LuaHelper gen_to_be_invoked = (LuaHelper)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 1) 
                {
                    
                        MMO_MemoryStream gen_ret = gen_to_be_invoked.CreateMemoryStream(  );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 2&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)) 
                {
                    byte[] _buffer = LuaAPI.lua_tobytes(L, 2);
                    
                        MMO_MemoryStream gen_ret = gen_to_be_invoked.CreateMemoryStream( _buffer );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to LuaHelper.CreateMemoryStream!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SendProto(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                LuaHelper gen_to_be_invoked = (LuaHelper)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    byte[] _buffer = LuaAPI.lua_tobytes(L, 2);
                    
                    gen_to_be_invoked.SendProto( _buffer );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddEventListtener(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                LuaHelper gen_to_be_invoked = (LuaHelper)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    ushort _protoCode = (ushort)LuaAPI.xlua_tointeger(L, 2);
                    SocketDispatcher.OnActionHandler _callBack = translator.GetDelegate<SocketDispatcher.OnActionHandler>(L, 3);
                    
                    gen_to_be_invoked.AddEventListtener( _protoCode, _callBack );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemoveEventListener(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                LuaHelper gen_to_be_invoked = (LuaHelper)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    ushort _protoCode = (ushort)LuaAPI.xlua_tointeger(L, 2);
                    SocketDispatcher.OnActionHandler _callBack = translator.GetDelegate<SocketDispatcher.OnActionHandler>(L, 3);
                    
                    gen_to_be_invoked.RemoveEventListener( _protoCode, _callBack );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LoadLuaView(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                LuaHelper gen_to_be_invoked = (LuaHelper)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _ctrName = LuaAPI.lua_tostring(L, 2);
                    
                    gen_to_be_invoked.LoadLuaView( _ctrName );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AutoLoadTexture(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                LuaHelper gen_to_be_invoked = (LuaHelper)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.GameObject _go = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
                    string _imgPath = LuaAPI.lua_tostring(L, 3);
                    string _imgName = LuaAPI.lua_tostring(L, 4);
                    
                    gen_to_be_invoked.AutoLoadTexture( _go, _imgPath, _imgName );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_UISceneCtrl(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LuaHelper gen_to_be_invoked = (LuaHelper)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.UISceneCtrl);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_UIViewUtil(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LuaHelper gen_to_be_invoked = (LuaHelper)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.UIViewUtil);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_AssetBundleMgr(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LuaHelper gen_to_be_invoked = (LuaHelper)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.AssetBundleMgr);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
		
		
		
		
    }
}
