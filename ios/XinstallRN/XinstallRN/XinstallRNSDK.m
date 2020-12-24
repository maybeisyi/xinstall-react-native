//
//  XinstallRNSDK.m
//  XinstallRNSDK
//
//  Created by Xinstall on 2020/12/16.
//  Copyright © 2020 shu bao. All rights reserved.
//

#import "XinstallRNSDK.h"

#if __has_include(<React/RCTBridge.h>)
  #import <React/RCTEventDispatcher.h>
  #import <React/RCTRootView.h>
  #import <React/RCTBridge.h>
  #import <React/RCTLog.h>
#elif __has_include("React/RCTBridge.h")
  #import "React/RCTEventDispatcher.h"
  #import "React/RCTRootView.h"
  #import "React/RCTBridge.h"
  #import "React/RCTLog.h"
#elif __has_include("RCTBridge.h")
  #import "RCTEventDispatcher.h"
  #import "RCTRootView.h"
  #import "RCTBridge.h"
  #import "RCTLog.h"
#endif

@interface XinstallRNSDK ()<XinstallDelegate>

/// 注册安装参数的 js 回调
@property (nonatomic, copy) RCTResponseSenderBlock registeredInstallCallback;
/// 注册唤醒参数的 js 回调
@property (nonatomic, copy) RCTResponseSenderBlock registeredWakeUpCallback;
/// 保存安装参数，因为唤醒的时机可能早于js安装唤醒
@property (nonatomic, strong) XinstallData *installData;
/// 保存唤醒参数，因为唤醒的时机可能早于js注册唤醒
@property (nonatomic, strong) XinstallData *wakeUpData;

@end


@implementation XinstallRNSDK

RCT_EXPORT_MODULE(Xinstall);

- (instancetype)init {
  if (self = [super init]) {
    [XinstallSDK initWithDelegate:self];
  }
  return self;
}

#pragma mark - XinstallDelegate Methods
- (void)xinstall_getInstallParams:(XinstallData *)appData {
  self.installData = appData;
  [self invokeRegisteredInstallCallbackWithChannelCode:appData.channelCode data:appData.data];
}

- (void)xinstall_getWakeUpParams:(XinstallData *)appData {
  self.wakeUpData = appData;
  [self invokeRegisteredWakeUpCallbackWithChannelCode:appData.channelCode data:appData.data];
}

#pragma mark - private Methods
/// 触发监听注册参数回调
/// @param channelCode 渠道号
/// @param data 自定义数据
- (void)invokeRegisteredInstallCallbackWithChannelCode:(NSString *)channelCode data:(NSDictionary *)data {
  if (self.registeredInstallCallback == nil) { return; }

  // 数据处理下
  NSDictionary *callbackRet = @{
      @"channelCode" : channelCode?:@"",
      @"data" : data?:@{}
  };
  self.registeredInstallCallback(@[callbackRet]);
}

- (void)invokeRegisteredWakeUpCallbackWithChannelCode:(NSString *)channelCode data:(NSDictionary *)data {
  if (self.registeredWakeUpCallback == nil) { return; }

  // 数据处理下
  NSDictionary *callbackRet = @{
      @"channelCode" : channelCode?:@"",
      @"data" : data?:@{}
  };
  self.registeredWakeUpCallback(@[callbackRet]);
}

#pragma mark - ReactNative 接口 Methods

RCT_EXPORT_METHOD(findEvents:(RCTResponseSenderBlock)callback)
{
  callback(@[[NSNull null], @"daiyi"]);
}

RCT_EXPORT_METHOD(addInstallEventListener:(RCTResponseSenderBlock)callback)
{
  self.registeredInstallCallback = callback;

  if (self.installData) {
      [self invokeRegisteredInstallCallbackWithChannelCode:self.installData.channelCode data:self.installData.data];
  }
}

RCT_EXPORT_METHOD(addWakeUpEventListener:(RCTResponseSenderBlock)callback)
{
  self.registeredWakeUpCallback = callback;

  if (self.wakeUpData) {
      [self invokeRegisteredWakeUpCallbackWithChannelCode:self.wakeUpData.channelCode data:self.wakeUpData.data];
  }
}

RCT_EXPORT_METHOD(reportRegister)
{
    [XinstallSDK reportRegister];
}

RCT_EXPORT_METHOD(reportEffect:(NSString *)effectID effectValue:(NSInteger)effectValue)
{
    [[XinstallSDK defaultManager] reportEffectPoint:effectID effectValue:effectValue];
}

@end
