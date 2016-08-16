/**
 * Created by qiepeipei on 16/8/15.
 */
'use strict';
import React, { PropTypes, Component } from 'react';
import {
    DeviceEventEmitter,
    NativeModules,
    Platform,
} from 'react-native'

var PushObj = NativeModules.BaiDuPush;

class Push{

    constructor (event) {

      
        //透传对象
        this.penetrate = {};

        //通知对象
        this.pushs = {};


        //状态对象
        this.statePush = {};


        //接收 透传消息事件
        DeviceEventEmitter.addListener(
            'PenetrateEvent', this._PenetrateEvent.bind(this)
        );

        //接收 通知消息事件
        DeviceEventEmitter.addListener(
            'PushEvent', this._PushEvent.bind(this)
        );

        //接收操作状态
        DeviceEventEmitter.addListener(
            'PushStateEvent',this._PushStateEvent.bind(this));


        //初始化推送
        if (Platform.OS === 'android') {

            this.statePush['init'] = event;
            PushObj.initialise();

        }else{
            PushObj.bindChannelWithCompleteHandler(event);
        }


    }

    //状态回调
    _PushStateEvent(event){

        //启动推送
        if(event['msgState'] == 1){

            if(event['status'] == 0){

                this.statePush['init'](0);

            }else{

                this.statePush['init'](-1);

            }

            //停止推送
        }else if(event['msgState'] == 2){

            if(event['status'] == 0){

                this.statePush['uninit'](0);

            }else{

                this.statePush['uninit'](-1);

            }

            //设置tag
        }else if(event['msgState'] == 3){

            if(event['status'] == 0){

                this.statePush['setTag'](0);

            }else{

                this.statePush['setTag'](-1);

            }
            //删除tag
        }else if(event['msgState'] == 4){

            if(event['status'] == 0){

                this.statePush['delTag'](0);

            }else{

                this.statePush['delTag'](-1);

            }

        }



    }



    //透传消息回调
    _PenetrateEvent(event){

        this.penetrate(event);

    }

    //通知消息回调
    _PushEvent(event){

        this.pushs(event);

    }

    //接收透传消息
    penetrateEvent(event){

        this.penetrate = event;

    }

    //接收通知消息
    pushEvent(event){

        this.pushs = event;

    }

    //恢复推送
    bindChannelWithCompleteHandler(event){

        //初始化推送
        if (Platform.OS === 'android') {

            this.statePush['init'] = event;
            PushObj.resumeWork();

        }else{
            PushObj.bindChannelWithCompleteHandler(event);
        }

    }

    //停止推送
    unbindChannelWithCompleteHandler(event){

        if (Platform.OS === 'android') {

            this.statePush['uninit'] = event;
            PushObj.stopWork();

        }else{
            PushObj.unbindChannelWithCompleteHandler(event);
        }

    }

    //设置tags
    setTag(tags,event) {

        if (Platform.OS === 'android') {

            this.statePush['setTag'] = event;
            PushObj.setTags(tags);

        }else{
            PushObj.setTag(tags, event)
        }


    }

    //删除tags
    delTag(tags,event) {

        if (Platform.OS === 'android') {

            this.statePush['delTag'] = event;
            PushObj.delTags(tags);

        }else{
            PushObj.delTag(tags, event)
        }

    }



}

module.exports = Push;