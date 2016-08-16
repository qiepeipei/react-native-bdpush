package com.example.baidupush;

import android.support.annotation.Nullable;
import android.util.Log;

import com.baidu.android.pushservice.PushConstants;
import com.baidu.android.pushservice.PushManager;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Created by qiepeipei on 16/8/13.
 */
public class PushModule extends ReactContextBaseJavaModule {

    static public PushModule myPush;

    public PushModule(ReactApplicationContext reactContext) {
        super(reactContext);
        myPush = this;
        initialise();

    }

    @Override
    public String getName() {
        return "BaiDuPush";
    }

    //发送透传消息
    public void sendPenetrateMsg(String msg){

        sendEvent1(getReactApplicationContext(), "PenetrateEvent", msg);

    }

    //发送通知消息
    public void sendPushMsg(String title,String description){

        sendEvent1(getReactApplicationContext(), "PushEvent", description);

    }

    //函数执行状态返回
    public void sendState(int status,int msgState){

        WritableMap params = Arguments.createMap();
        params.putInt("status", status); //0成功
        params.putInt("msgState", msgState); //1 开启推送  2停止推送 3设置tags 4取消tags
        sendEvent(getReactApplicationContext(), "PushStateEvent", params);

    }



    private void sendEvent(ReactContext reactContext,
                           String eventName,
                           @Nullable WritableMap params) {
        reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(eventName, params);
    }

    private void sendEvent1(ReactContext reactContext,
                           String eventName,
                           @Nullable String params) {
        reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(eventName, params);
    }



    //初始化
    @ReactMethod
    public void initialise(){
        Log.d("百度推送", "正在初始化");
        PushManager.startWork(getReactApplicationContext(), PushConstants.LOGIN_TYPE_API_KEY,Utils.getMetaValue(getReactApplicationContext(), "api_key"));
    }


    //停止推送
    @ReactMethod
    public void stopWork(){
        PushManager.stopWork(getReactApplicationContext());
    }

    //恢复推送
    @ReactMethod
    public void resumeWork(){
        PushManager.resumeWork(getReactApplicationContext());
    }


    //设置Tag
    @ReactMethod
    public void setTags(String tags){

        List<String> list = new ArrayList();
        list.add(tags);
        PushManager.setTags(getReactApplicationContext(),list);

    }

    //删除Tag
    @ReactMethod
    public void delTags(String tags){

        List<String> list = new ArrayList();
        list.add(tags);

        PushManager.delTags(getReactApplicationContext(),list);

    }

//    //开启精确LBS推送模式
//    @ReactMethod
//    public void enableLbs(){
//
//        PushManager.enableLbs(getReactApplicationContext());
//
//    }
//
//    //关闭精确LBS推送模式
//    @ReactMethod
//    public void disableLbs(){
//
//        PushManager.disableLbs(getReactApplicationContext());
//
//    }






}
