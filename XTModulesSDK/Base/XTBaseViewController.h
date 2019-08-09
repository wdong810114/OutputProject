//
//  XTBaseViewController.h
//  XTModulesSDK
//
//  Created by wdd on 2019/7/22.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XTMacro.h"
#import "XTAppUtils.h"
#import "XTModulesManager.h"

@interface XTBaseViewController : UIViewController

- (void)setLeftBarButtonItem:(SEL)action image:(NSString *)image highlightedImage:(NSString *)highlightedImage;
- (void)setRightBarButtonItem:(SEL)action image:(NSString *)image highlightedImage:(NSString *)highlightedImage;
- (void)setLeftBarButtonItem:(SEL)action title:(NSString *)title;
- (void)setRightBarButtonItem:(SEL)action title:(NSString *)title;

- (void)showAlert:(NSString *)title;
- (void)showAlert:(NSString *)title shouldGoBack:(BOOL)shouldGoBack;

- (void)showAuthorizationAlert:(NSString *)title;

@end

@interface XTBaseViewController (Loading)

- (BOOL)isLoading;
- (void)showLoading;
- (void)hideLoading;

@end

@interface XTBaseViewController (Toast)

- (void)showToastWithText:(NSString *)text;

@end
