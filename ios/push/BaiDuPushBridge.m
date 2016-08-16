//
//  BaiDuPushBridge.m
//  rn31
//
//  Created by qiepeipei on 16/8/14.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "BaiDuPushBridge.h"

@interface RCT_EXTERN_MODULE(BaiDuPush, NSObject)

RCT_EXTERN_METHOD(bindChannelWithCompleteHandler:(RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(unbindChannelWithCompleteHandler:(RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(setTag:(NSString*)tags callback:(RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(delTag:(NSString*)tags callback:(RCTResponseSenderBlock)callback)

@end