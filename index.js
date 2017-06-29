/**
 * Created by qiepeipei on 17/6/22.
 */
'use strict';
import React, { PropTypes, Component } from 'react';
import {
    DeviceEventEmitter,
    NativeModules,
    Platform,
    NativeAppEventEmitter,
    AppState
} from 'react-native'

var PushObj = NativeModules.BaiDuPushManager;

class BaiDuPush{

constructor () {
  this.ReceiveMessageObj = null;
  this.BackstageMessageObj = null;
}
//监听前台消息
monitorReceiveMessage(callBack){
    //处于后台时，拦截收到的消息
    // if(AppState.currentState == 'background') {
    //     return;
    // }
    if(Platform.OS == 'ios'){
        this.ReceiveMessageObj = NativeAppEventEmitter.addListener(
        PushObj.DidReceiveMessage,callBack);
    }else{
        this.ReceiveMessageObj = DeviceEventEmitter.addListener(
        PushObj.DidReceiveMessage,(data)=>{
            let obj = {};
            obj.title = data.title;
            obj.description = data.description;
            obj.customContentString = JSON.parse(data.customContentString);
            callBack(obj);
        });
    }
   

}

//监听后台打开消息
monitorBackstageOpenMessage(callBack){

 if(Platform.OS == 'ios'){
        this.BackstageMessageObj = NativeAppEventEmitter.addListener(
        PushObj.DidOpenMessage,callBack);
    }else{
        this.BackstageMessageObj = DeviceEventEmitter.addListener(
        PushObj.DidOpenMessage,(data)=>{
            let obj = {};
            obj.title = data.title;
            obj.description = data.description;
            obj.customContentString = JSON.parse(data.customContentString);
            callBack(obj);
        });
    }

}

//取消消息监听
monitorMessageCancel(){

    if(this.ReceiveMessageObj){
        this.ReceiveMessageObj.remove();
    }

    if(this.BackstageMessageObj){
        this.BackstageMessageObj.remove();
    }
    
}

//获取ChannelId
async getChannelId(){
   try {
    return await PushObj.getChannelId();
  } catch (e) {
    return null;
  }
}



testSend(){
    PushObj.testPrint("hello world");
}



}
export default new BaiDuPush();

