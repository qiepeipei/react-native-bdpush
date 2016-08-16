package com.example.baidupush;

import android.content.Context;
import android.content.Intent;
import android.util.Log;

import com.baidu.android.pushservice.PushConstants;
import com.baidu.android.pushservice.PushMessageReceiver;

import java.util.List;

/**
 * Created by qiepeipei on 16/8/13.
 */
public class MyPushMessageReceiver extends PushMessageReceiver {


    @Override
    public void onBind(Context context, int errorCode, String appid,
                       String userId, String channelId, String requestId) {

        String responseString = "onBind errorCode=" + errorCode + " appid="
                + appid + " userId=" + userId + " channelId=" + channelId
                + " requestId=" + requestId;
        Log.d("百度推送", responseString);

        if (errorCode == 0) {
            // 绑定成功
            Log.d("百度推送", "绑定成功");
            PushModule.myPush.sendState(0,1);
        }else{
            Log.d("百度推送", "绑定失败");
            PushModule.myPush.sendState(-1,1);
        }



    }

    @Override
    public void onUnbind(Context context, int errorCode, String s) {
        Log.d("百度推送", "onUnbind");
        if(errorCode == 0){

            PushModule.myPush.sendState(0,2);

        }else {

            PushModule.myPush.sendState(-1,2);

        }

    }

    @Override
    public void onSetTags(Context context, int errorCode, List<String> list, List<String> list1, String s) {
        Log.d("百度推送", "onSetTags");

        if(errorCode == 0){

            PushModule.myPush.sendState(0,3);

        }else {

            PushModule.myPush.sendState(-1,3);

        }

    }

    @Override
    public void onDelTags(Context context, int errorCode, List<String> list, List<String> list1, String s) {
        Log.d("百度推送", "onDelTags");

        if(errorCode == 0){

            PushModule.myPush.sendState(0,4);

        }else {

            PushModule.myPush.sendState(-1,4);

        }

    }

    @Override
    public void onListTags(Context context, int i, List<String> list, String s) {
        Log.d("百度推送", "onListTags");
    }

    //接收透传消息
    /*
    *   context 上下文
        message 推送的消息
        customContentString 自定义内容，为空或者json字符串
    * */
    @Override
    public void onMessage(Context context, String message, String customContentString) {
        Log.d("百度推送", "收到透传消息");

        PushModule.myPush.sendPenetrateMsg(message);

    }

    /*接收通知点击的函数

    *   context 上下文
        title 推送的通知的标题
        description 推送的通知的描述
        customContentString 自定义内容，为空或者json字符串
    * */
    @Override
    public void onNotificationClicked(Context context, String title, String description, String customContentString) {
        Log.d("百度推送", "已点击通知栏");

        String packageName = context.getApplicationContext().getPackageName();
        Intent launchIntent = context.getPackageManager().getLaunchIntentForPackage(packageName);
        launchIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        context.startActivity(launchIntent);
        PushModule.myPush.sendPushMsg(title,description);
    }

    /*接收通知到达的函数
    *
    *   context 上下文
        title 推送的通知的标题
        description 推送的通知的描述
        customContentString 自定义内容，为空或者json字符串

    * */

    @Override
    public void onNotificationArrived(Context context, String title, String description, String customContentString) {

        Log.d("百度推送", "收到通知消息");


    }
}
