//  1.1.10
//  XinstallSDK.h
//  XinstallSDK
//
//  Created by Xinstall on 2020/5/7.
//  Copyright © 2020 shu bao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XinstallData.h"



@protocol XinstallDelegate <NSObject>
@optional

/**
 * 唤醒时获取h5页面动态参数（如果是渠道链接，渠道编号会一起返回）
 * @param appData 动态参数对象
 * appData 的 uo co 数据如果前端传入不是正常的json 数据，会返回前端传入的String ，如果为正常json 数据 会返回字典或数组
 */
- (void)xinstall_getWakeUpParams:(nullable XinstallData *)appData;

/**
 * 安装时获取h5页面动态参数（如果是渠道链接，渠道编号会一起返回）
 * @param appData 动态参数对象
 * appData 的 uo co 数据如果前端传入不是正常的json 数据，会返回前端传入的String ，如果为正常json 数据 会返回字典或数组
 */
- (void)xinstall_getInstallParams:(nullable XinstallData *)appData;

@end

@interface XinstallSDK : NSObject
#pragma mark - properties methods
/**
 * 获取sdk当前版本号
 */
+ (NSString *_Nullable)sdkVersion;

/**
 * SDK单例,returns a previously instantiated singleton instance of the API.
 */
+ (instancetype _Nullable)defaultManager;

/**
 * 初始化Xinstall SDK
 * 调用该方法前，需在Info.plist文件中配置键值对,键为com.xinstall.APP_KEY不能修改，值为相应的应用的appKey，可在xinstall官方后台查看
 */
+ (void)initWithDelegate:(id<XinstallDelegate> _Nonnull)delegate;


///----------------------
/// @name 获取安装的动态参数
///----------------------

/// 对象为空则代表非本次安装
@property (nonatomic, strong) XinstallData * __nullable installData;

/**
 * 处理 通用链接
 * @param userActivity 存储了页面信息，包括url
 * @return bool URL是否被Xinstall识别
 */
+ (BOOL)continueUserActivity:(NSUserActivity *_Nullable)userActivity;

///--------------
/// @name 统计相关
///--------------


/**
 * 注册量统计
 *
 * 使用xinstall 控制中心提供的渠道统计时，在App用户注册完成后调用，可以统计渠道注册量。
 * 必须在注册成功的时再调用该方法，避免重复调用，否则可能导致注册统计不准
 */
+ (void)reportRegister;


/**
 * 渠道效果统计
 *
 * 目前SDK采用定时上报策略，时间间隔由服务器控制
 * e.g.可统计用户支付消费情况,点击次数等
 *
 * @param effectID 效果点ID
 * @param effectValue 效果点值（如果是人民币金额，请以分为计量单位）
 */
- (void)reportEffectPoint:(NSString *_Nonnull)effectID effectValue:(long)effectValue;

@end
