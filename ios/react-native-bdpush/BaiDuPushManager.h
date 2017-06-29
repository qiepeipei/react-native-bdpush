//
//  BaiDuPushManager.h
//  react-native-bdpush
//
//  Created by 郄佩佩 on 2017/6/21.
//  Copyright © 2017年 郄佩佩. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <UIKit/UIKit.h>
@interface BaiDuPushManager : NSObject <RCTBridgeModule>

+ (void)registerWithAppkey:(NSString *)appkey launchOptions:(NSDictionary *)launchOptions application:(UIApplication *)application;

+ (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

+ (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

+ (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;


@property (nonatomic, copy) id bPush;

@end
