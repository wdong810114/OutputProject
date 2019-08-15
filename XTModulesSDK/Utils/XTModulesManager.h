//
//  XTModulesManager.h
//  XTModulesSDK
//
//  Created by wdd on 2019/7/22.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  生活服务支付成功通知
 */
extern NSString * const XTLifeServicePayDidSuccessNotification;

/**
 *  用户令牌失效通知
 */
extern NSString * const XTUserTokenInvalidNotification;

typedef NS_ENUM(NSInteger, XTModuleShowMode)
{
    XTModuleShowModePush = 0,
    XTModuleShowModePresent
};

@interface XTError : NSObject

/**
 *  错误编码
 *  0：正常
 *  -1：源视图控制器为空
 *  -2：显示模式是Push，但源视图控制器不在导航控制器中
 *  -3：盛京通设备签名为空
 *  -4：盛京通用户ID为空
 *  -5：手机号为空
 */
@property (nonatomic, assign) NSInteger code;
/**
 *  错误信息
 */
@property (nonatomic, copy) NSString *message;

@end

@interface XTModulesManager : NSObject

@property (nonatomic, weak, readonly) UIViewController *sourceVC;
@property (nonatomic, assign, readonly) XTModuleShowMode mode;
@property (nonatomic, copy, readonly) NSString *accessKey;
@property (nonatomic, copy, readonly) NSString *userId;
@property (nonatomic, copy, readonly) NSString *phone;

+ (instancetype)sharedManager;

/**
 *  判断网络是否可达
 *
 *  @return YES：可达，NO：不可达
 */
- (BOOL)isReachable;

/**
 *  显示话费充值
 *
 *  @param sourceVC 源视图控制器
 *  @param mode 模块显示模式
 *  @param accessKey 盛京通设备签名
 *  @param userId 盛京通用户ID
 *  @param phone 手机号
 *
 *  @return 错误信息
 */
- (XTError *)showPhoneRechargeWithSourceVC:(UIViewController *)sourceVC mode:(XTModuleShowMode)mode accessKey:(NSString *)accessKey userId:(NSString *)userId phone:(NSString *)phone;

/**
 *  显示特惠加油
 *
 *  @param sourceVC 源视图控制器
 *  @param mode 模块显示模式
 *  @param accessKey 盛京通设备签名
 *  @param userId 盛京通用户ID
 *  @param phone 手机号
 *
 *  @return 错误信息
 */
- (XTError *)showRefuelWithSourceVC:(UIViewController *)sourceVC mode:(XTModuleShowMode)mode accessKey:(NSString *)accessKey userId:(NSString *)userId phone:(NSString *)phone;

/**
 *  显示生活缴费
 *
 *  @param sourceVC 源视图控制器
 *  @param mode 模块显示模式
 *  @param accessKey 盛京通设备签名
 *  @param userId 盛京通用户ID
 *  @param phone 手机号
 *
 *  @return 错误信息
 */
- (XTError *)showLifePaymentWithSourceVC:(UIViewController *)sourceVC mode:(XTModuleShowMode)mode accessKey:(NSString *)accessKey userId:(NSString *)userId phone:(NSString *)phone;

@end
