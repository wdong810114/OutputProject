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
 *  用户令牌失效通知
 */
extern NSString * const XTUserTokenInvalidNotification;
/**
 *  生活服务下单成功通知
 *  调起生活服务模块的sourceVC需注册此通知，模块内下单成功后会将订单相关信息发送通知给sourceVC。
 *  订单相关信息的结构如下：
 *  @{@"orderType" : 订单类型, // 0：话费充值 1：特惠加油 2：水费 3：电费 4：燃气费
 *    @"orderId" : 订单ID,
 *    @"orderAmount" : 订单金额}
 */
extern NSString * const XTLifeServicePlaceOrderDidSuccessNotification;
/**
 *  生活服务支付成功通知
 *  App端完成支付相关操作后，需发送此通知给模块。
 */
extern NSString * const XTLifeServicePayDidSuccessNotification;

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
