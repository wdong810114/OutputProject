//
//  XTBaseNavigationController.m
//  XTModulesSDK
//
//  Created by wdd on 2019/7/22.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTBaseNavigationController.h"

#import "XTBaseViewController.h"

@interface XTBaseNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation XTBaseNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    XTBaseNavigationController *navigationController = [super initWithRootViewController:rootViewController];
    navigationController.interactivePopGestureRecognizer.delegate = self;
    
    navigationController.navigationBar.translucent = NO;
    [navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    navigationController.navigationBar.shadowImage = nil;
    navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName : XTBoldFont(18.0), NSForegroundColorAttributeName : XTBrandBlackColor};
    
    return navigationController;
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        if (self.viewControllers.count == 1) {
            return NO;
        }
        
        UIViewController *lastViewController = self.viewControllers.lastObject;
        if ([self.viewControllers.lastObject isKindOfClass:[XTBaseViewController class]]) {
            if ([(XTBaseViewController *)lastViewController isLoading]) {
                return NO;
            }
        }
    }
    
    return YES;
}

@end
