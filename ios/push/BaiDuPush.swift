//
//  BaiDuPush.swift
//  rn31
//
//  Created by qiepeipei on 16/8/14.
//  Copyright © 2016年 Facebook. All rights reserved.
//

import UIKit

@objc(BaiDuPush)
class BaiDuPush: NSObject {
  var bridge: RCTBridge!
  
  override init() {
    
    super.init()
    //消息初始化
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.getMyName), name:"NotificationIdentifier", object: nil)
    
  }
  
  //收到透传推送消息
  static func receivePushMessages(msg:String){
    
    dispatch_async(dispatch_get_main_queue()){
      
      let dic = ["msg":msg,"state":1];
      NSNotificationCenter.defaultCenter().postNotificationName("NotificationIdentifier", object: dic)
      
    }
    
  }
  
  //收到通知推送消息
  static func pushNotificationMessages(msg:String){
    
    
    dispatch_async(dispatch_get_main_queue()){
      
      let dic = ["msg":msg,"state":2];
      NSNotificationCenter.defaultCenter().postNotificationName("NotificationIdentifier", object: dic)
      
    }
    
  }
  
  //消息回调
  func getMyName(notification:NSNotification){
    
    let state = notification.object?.valueForKey("state") as? Int
    let msg = notification.object?.valueForKey("msg") as? String
    self.event_penetrate_msg(msg!,state:state!)
    
  }
  
  
  //发送消息  1透传 2通知
  func event_penetrate_msg(msg:String,state:Int){
    
    if state == 1{
      
      //发送透传消息
      self.bridge.eventDispatcher().sendDeviceEventWithName("PenetrateEvent",body: msg)
      
    }else{
      
      //发送通知消息
      self.bridge.eventDispatcher().sendDeviceEventWithName("PushEvent",body: msg)
      
    }
    
  }
  
  //在 App 启动时注册百度云推送服务，需要提供 Apikey
  static func registerChannel(application:NSDictionary,apiKey:String,pushMode:BPushMode){
    
    dispatch_async(dispatch_get_main_queue()){

      BPush.registerChannel(application as [NSObject : AnyObject], apiKey: apiKey, pushMode: pushMode, withFirstAction: "打开", withSecondAction: "回复", withCategory: "test", useBehaviorTextInput: true, isDebug: true)
      
    }
    
  }
  
  // 禁用地理位置推送 需要再绑定接口前调用。
  static func disableLbs(){
    
    dispatch_async(dispatch_get_main_queue()){
      
        BPush.disableLbs()

    }

    
  }
  
  //推送消息的反馈和统计
  static func handleNotification(userInfo:NSDictionary){
    
    dispatch_async(dispatch_get_main_queue()){
      
      BPush.handleNotification(userInfo as [NSObject : AnyObject])

    }

  }
  
  //向百度云注册
  static func registerDeviceToken(deviceToken:NSData){
    
    dispatch_async(dispatch_get_main_queue()){
      
      BPush.registerDeviceToken(deviceToken)
      
    }
    
  }
  
  //绑定Push服务通道
  @objc func bindChannelWithCompleteHandler(callback: (NSObject) -> ()){
    
    dispatch_async(dispatch_get_main_queue()){
    
      
      BPush.bindChannelWithCompleteHandler { (result:AnyObject!, error:NSError!) in
        
        if error != nil{
          callback([-2])
          return
        }
        
        
        // 确认绑定成功
        if ((result.objectForKey("error_code") != nil) && (result.objectForKey("error_code")?.intValue != 0)){
          
          callback([-1])
          return
          
        }else{
          
          callback([0])
          print("绑定成功")
          
        }
        
        
      }


    }

  }
  
  
  //解除绑定Push服务通道
  @objc func unbindChannelWithCompleteHandler(callback: (NSObject) -> ()){
    
    dispatch_async(dispatch_get_main_queue()){
      
      BPush.unbindChannelWithCompleteHandler { (result:AnyObject!, error:NSError!) in
        
        if error != nil{
          callback([-2])
          return
        }
        
        // 确认是否解绑绑定成功
        if result.objectForKey("request_id") == nil{
          callback([-1])
          return
          
        }else{
          
          callback([0])
          print("解绑成功")
          
        }
      }

    }
    
  }
  
  //设置tags
  @objc func setTag(tags:String,callback: (NSObject) -> ()){
    
    dispatch_async(dispatch_get_main_queue()){
    
      BPush.setTag(tags, withCompleteHandler: { (result:AnyObject!, error:NSError!) in
        
        // 确认是否设置成功
        if ((result.objectForKey("error_code") != nil) && (result.objectForKey("error_code")?.intValue == 0)){
          
          callback([0])
          return
          
        }else{
          
          callback([-1])
          print("设置tags成功")
          
        }
        
        
      })


    }
    
    
  }
  
  //删除tags
  @objc func delTag(tags:String,callback: (NSObject) -> ()){
    
    dispatch_async(dispatch_get_main_queue()){
    

      BPush.delTag(tags, withCompleteHandler: { (result:AnyObject!, error:NSError!) in
      
        // 确认是否删除成功
        if ((result.objectForKey("error_code") != nil) && (result.objectForKey("error_code")?.intValue == 0)){
          
          callback([0])
          return
          
        }else{
          
          callback([-1])
          print("删除tags成功")
          
        }
        
        
      })

    
    }
    
    
  }
  

  
  
  
  

 
  
}