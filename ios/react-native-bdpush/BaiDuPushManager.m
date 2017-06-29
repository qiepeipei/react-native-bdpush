//
//  BaiDuPushManager.m
//  react-native-bdpush
//
//  Created by 郄佩/Users/qiepeipei/Desktop/react-native-bdpush/ios/push/BaiDuPushBridge.h佩 on 2017/6/21.
//  Copyright © 2017年 郄佩佩. All rights reserved.
//

#import "BaiDuPushManager.h"
#import <Foundation/Foundation.h>
#import <React/RCTEventDispatcher.h>
#import "BPush.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
static NSString * const DidReceiveMessage = @"DidReceiveMessage";
static NSString * const DidOpenMessage = @"DidOpenMessage";
static BaiDuPushManager *_instance = nil;
static BOOL isBackGroundActivateApplication;
@interface BaiDuPushManager ()
@property NSString *ChannelId;
@end

@implementation BaiDuPushManager
@synthesize bridge = _bridge;
RCT_EXPORT_MODULE()

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(_instance == nil) {
            
            _instance = [[self alloc] init];
        }
    });
    return _instance;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    if(_instance == nil) {
      
      _instance = [super allocWithZone:zone];
      
    }
  });
  return _instance;
}

//初始化注册
+ (void)registerWithAppkey:(NSString *)appkey launchOptions:(NSDictionary *)launchOptions application:(UIApplication *)application {
  
  // iOS10 下需要使用新的 API
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                            // Enable or disable features based on authorization.
                            if (granted) {
                              [application registerForRemoteNotifications];
                            }
                          }];
#endif
  }
  else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
    UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
  }else {
    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
  }
  


  [BPush registerChannel:launchOptions apiKey:appkey pushMode:BPushModeDevelopment withFirstAction:@"打开" withSecondAction:@"关闭" withCategory:@"test" useBehaviorTextInput:YES isDebug:YES];
  
  // 禁用地理位置推送 需要再绑定接口前调用。
  [BPush disableLbs];
  
  // App 是用户点击推送消息启动
  NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
  if (userInfo) {
    [BPush handleNotification:userInfo];
  }
#if TARGET_IPHONE_SIMULATOR
  Byte dt[32] = {0xc6, 0x1e, 0x5a, 0x13, 0x2d, 0x04, 0x83, 0x82, 0x12, 0x4c, 0x26, 0xcd, 0x0c, 0x16, 0xf6, 0x7c, 0x74, 0x78, 0xb3, 0x5f, 0x6b, 0x37, 0x0a, 0x42, 0x4f, 0xe7, 0x97, 0xdc, 0x9f, 0x3a, 0x54, 0x10};
  [self application:application didRegisterForRemoteNotificationsWithDeviceToken:[NSData dataWithBytes:dt length:32]];
#endif
  //角标清0
  [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
  

  

}


+ (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
  
  completionHandler(UIBackgroundFetchResultNewData);
  
  // 应用在前台，不跳转页面，让用户选择。
  if (application.applicationState == UIApplicationStateActive) {

    
    NSLog(@"应用在前台,收到一条消息");
    
    NSMutableDictionary* contentMap = [[NSMutableDictionary alloc] init];
    NSMutableDictionary* tmpMap = [[NSMutableDictionary alloc] init];
    [contentMap setValue:userInfo[@"aps"][@"alert"] forKey:@"description"];
    for (NSString *key in userInfo) {
      if(![key isEqualToString:@"aps"]){
        [tmpMap setValue:userInfo[key] forKey:key];
      }
    }
    [contentMap setValue:tmpMap forKey:@"customContentString"];
    [[BaiDuPushManager sharedInstance] sendMessage:contentMap type:@"1"];

    UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"收到一条消息" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    
  }
  //应用在后台，点击后响应事件。
  if (application.applicationState == UIApplicationStateInactive && !isBackGroundActivateApplication)
  {
    
    NSLog(@"应用在后台,收到一条消息");
    
    NSMutableDictionary* contentMap = [[NSMutableDictionary alloc] init];
    NSMutableDictionary* tmpMap = [[NSMutableDictionary alloc] init];
    [contentMap setValue:userInfo[@"aps"][@"alert"] forKey:@"description"];
    for (NSString *key in userInfo) {
      if(![key isEqualToString:@"aps"]){
        [tmpMap setValue:userInfo[key] forKey:key];
      }
    }
    [contentMap setValue:tmpMap forKey:@"customContentString"];
    [[BaiDuPushManager sharedInstance] sendMessage:contentMap type:@"2"];
    
  }
  // 应用在后台。当后台设置aps字段里的 content-available 值为 1 并开启远程通知激活应用的选项
  if (application.applicationState == UIApplicationStateBackground) {
    // 此处可以选择激活应用提前下载邮件图片等内容。
    isBackGroundActivateApplication = YES;
  }
  
}

+ (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
  
  [BPush registerDeviceToken:deviceToken];
  [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
    
    // 需要在绑定成功后进行 settag listtag deletetag unbind 操作否则会失败
    
    // 网络错误
    if (error) {
      return ;
    }
    if (result) {
      
      // 确认绑定成功
      if ([result[@"error_code"]intValue]!=0) {
        return;
      }
      
    }
  }];
  
  
}

+ (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
  
  NSLog(@"DeviceToken 获取失败，原因：%@",error);
  
}

- (NSDictionary<NSString *, id> *)constantsToExport {
  return @{
           DidReceiveMessage: DidReceiveMessage,
           DidOpenMessage: DidOpenMessage,
           };
}


//获取ChannelId
RCT_EXPORT_METHOD(getChannelId:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  @try {
    
    resolve([BPush getChannelId]);
    
  } @catch (NSException *exception) {
    NSError *error = [NSError errorWithDomain:@"获取ChannelId出错！" code:1 userInfo: exception.userInfo];
    reject(exception.name,exception.reason,error);
    
  }
  
  
}


//发送js事件。 type=1  前台消息。 2 表示后台消息 打开应用
- (void)sendMessage:(NSDictionary *)userInfo type:(NSString*)type
{
  
  if([type isEqualToString:@"1"]){

    [self.bridge.eventDispatcher sendAppEventWithName:@"DidReceiveMessage" body:userInfo];
    
  }else{
    
    [self.bridge.eventDispatcher sendAppEventWithName:@"DidOpenMessage" body:userInfo];
  }


  
}


@end
