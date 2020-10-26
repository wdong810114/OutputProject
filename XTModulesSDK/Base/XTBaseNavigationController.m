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
    navigationController.navigationBar.barTintColor = XTColorFromHex(0xF3F3F3);
    navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:18.0 weight:UIFontWeightSemibold], NSForegroundColorAttributeName : XTColorFromHex(0x111111)};
    
    return navigationController;
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}

- (UIModalPresentationStyle)modalPresentationStyle
{
    return UIModalPresentationFullScreen;
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
