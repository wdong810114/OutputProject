//
//  XTModulesManager.m
//  XTModulesSDK
//
//  Created by wdd on 2019/7/22.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTModulesManager.h"

#import "Reachability.h"
#import "XTBaseNavigationController.h"
#import "XTPhoneRechargeViewController.h"
#import "XTRefuelViewController.h"
#import "XTLifePaymentViewController.h"

NSString * const XTUserTokenInvalidNotification = @"XTUserTokenInvalidNotification";
NSString * const XTLifeServicePlaceOrderDidSuccessNotification = @"XTLifeServicePlaceOrderDidSuccessNotification";
NSString * const XTLifeServicePayDidSuccessNotification = @"XTLifeServicePayDidSuccessNotification";

@implementation XTError

@end

@interface XTModulesManager ()

@property (nonatomic, strong) Reachability *reachable;

@property (nonatomic, weak) UIViewController *sourceVC;
@property (nonatomic, assign) XTModuleShowMode mode;
@property (nonatomic, copy) NSString *accessKey;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *phone;

- (XTError *)checkWithSourceVC:(UIViewController *)sourceVC mode:(XTModuleShowMode)mode accessKey:(NSString *)accessKey userId:(NSString *)userId phone:(NSString *)phone;

@end

@implementation XTModulesManager

+ (instancetype)sharedManager
{
    static XTModulesManager *modulesManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        modulesManager = [[self alloc] init];
    });
    
    return modulesManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.reachable = [Reachability reachabilityForInternetConnection];
    }
    
    return self;
}

#pragma mark - Private
- (XTError *)checkWithSourceVC:(UIViewController *)sourceVC mode:(XTModuleShowMode)mode accessKey:(NSString *)accessKey userId:(NSString *)userId phone:(NSString *)phone
{
    if (!sourceVC) {
        XTError *error = [[XTError alloc] init];
        error.code = -1;
        error.message = @"源视图控制器为空";
        return error;
    }
    
    if (XTModuleShowModePush == mode && !sourceVC.navigationController) {
        XTError *error = [[XTError alloc] init];
        error.code = -2;
        error.message = @"显示模式是Push，但源视图控制器不在导航控制器中";
        return error;
    }
    
    if (!accessKey || accessKey.length == 0) {
        XTError *error = [[XTError alloc] init];
        error.code = -3;
        error.message = @"盛京通设备签名为空";
        return error;
    }
    
    if (!userId || userId.length == 0) {
        XTError *error = [[XTError alloc] init];
        error.code = -4;
        error.message = @"盛京通用户ID为空";
        return error;
    }
    
    if (!phone || phone.length == 0) {
        XTError *error = [[XTError alloc] init];
        error.code = -5;
        error.message = @"手机号为空";
        return error;
    }
    
    return nil;
}

#pragma mark - Public
- (BOOL)isReachable
{
    return ([self.reachable currentReachabilityStatus] != NotReachable);
}

- (XTError *)showPhoneRechargeWithSourceVC:(UIViewController *)sourceVC mode:(XTModuleShowMode)mode accessKey:(NSString *)accessKey userId:(NSString *)userId phone:(NSString *)phone
{
    XTError *error = [self checkWithSourceVC:sourceVC mode:mode accessKey:accessKey userId:userId phone:phone];
    if (error) {
        return error;
    }
    
    self.sourceVC = sourceVC;
    self.mode = mode;
    self.accessKey = accessKey;
    self.userId = userId;
    self.phone = phone;
    
    if (XTModuleShowModePush == mode) {
        XTPhoneRechargeViewController *vc = [[XTPhoneRechargeViewController alloc] init];
        if (sourceVC.navigationController.viewControllers.count == 1) {
            vc.hidesBottomBarWhenPushed = YES;
        }
        [sourceVC.navigationController pushViewController:vc animated:YES];
    } else {
        XTPhoneRechargeViewController *vc = [[XTPhoneRechargeViewController alloc] init];
        XTBaseNavigationController *navigationController = [[XTBaseNavigationController alloc] initWithRootViewController:vc];
        [sourceVC presentViewController:navigationController animated:YES completion:nil];
    }
    
    return nil;
}

- (XTError *)showRefuelWithSourceVC:(UIViewController *)sourceVC mode:(XTModuleShowMode)mode accessKey:(NSString *)accessKey userId:(NSString *)userId phone:(NSString *)phone
{
    XTError *error = [self checkWithSourceVC:sourceVC mode:mode accessKey:accessKey userId:userId phone:phone];
    if (error) {
        return error;
    }
    
    self.sourceVC = sourceVC;
    self.mode = mode;
    self.accessKey = accessKey;
    self.userId = userId;
    self.phone = phone;
    
    if (XTModuleShowModePush == mode) {
        XTRefuelViewController *vc = [[XTRefuelViewController alloc] init];
        if (sourceVC.navigationController.viewControllers.count == 1) {
            vc.hidesBottomBarWhenPushed = YES;
        }
        [sourceVC.navigationController pushViewController:vc animated:YES];
    } else {
        XTRefuelViewController *vc = [[XTRefuelViewController alloc] init];
        XTBaseNavigationController *navigationController = [[XTBaseNavigationController alloc] initWithRootViewController:vc];
        [sourceVC presentViewController:navigationController animated:YES completion:nil];
    }
    
    return nil;
}

- (XTError *)showLifePaymentWithSourceVC:(UIViewController *)sourceVC mode:(XTModuleShowMode)mode accessKey:(NSString *)accessKey userId:(NSString *)userId phone:(NSString *)phone
{
    XTError *error = [self checkWithSourceVC:sourceVC mode:mode accessKey:accessKey userId:userId phone:phone];
    if (error) {
        return error;
    }
    
    self.sourceVC = sourceVC;
    self.mode = mode;
    self.accessKey = accessKey;
    self.userId = userId;
    self.phone = phone;
    
    if (XTModuleShowModePush == mode) {
        XTLifePaymentViewController *vc = [[XTLifePaymentViewController alloc] init];
        if (sourceVC.navigationController.viewControllers.count == 1) {
            vc.hidesBottomBarWhenPushed = YES;
        }
        [sourceVC.navigationController pushViewController:vc animated:YES];
    } else {
        XTLifePaymentViewController *vc = [[XTLifePaymentViewController alloc] init];
        XTBaseNavigationController *navigationController = [[XTBaseNavigationController alloc] initWithRootViewController:vc];
        [sourceVC presentViewController:navigationController animated:YES completion:nil];
    }
    
    return nil;
}

@end
