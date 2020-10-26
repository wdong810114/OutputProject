//
//  XTBaseViewController.m
//  XTModulesSDK
//
//  Created by wdd on 2019/7/22.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTBaseViewController.h"

#import "MBProgressHUD.h"
#import "XTAlertView.h"

@interface XTBaseViewController () <MBProgressHUDDelegate>
{
    BOOL _bShouldGoBack;
    
    MBProgressHUD *_loadingView;
}

@end

@implementation XTBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if (@available(iOS 11.0, *)) {
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.view.backgroundColor = XTViewBGColor;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"%@ didReceiveMemoryWarning", [NSString stringWithUTF8String:object_getClassName(self)]);
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (UIModalPresentationStyle)modalPresentationStyle
{
    return UIModalPresentationFullScreen;
}

#pragma mark - Public
- (void)setLeftBarButtonItem:(SEL)action image:(NSString *)image highlightedImage:(NSString *)highlightedImage
{
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 32.0, 44.0)];
    customView.backgroundColor = [UIColor clearColor];
    
    UIButton *actionButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(customView.bounds), CGRectGetHeight(customView.bounds))];
    actionButton.backgroundColor = [UIColor clearColor];
    [actionButton setImage:[UIImage imageNamed:XTModulesSDKImage(image)] forState:UIControlStateNormal];
    [actionButton setImage:[UIImage imageNamed:XTModulesSDKImage(highlightedImage)] forState:UIControlStateHighlighted];
    [actionButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:actionButton];
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    self.navigationItem.leftBarButtonItems = @[leftButtonItem];
}

- (void)setRightBarButtonItem:(SEL)action image:(NSString *)image highlightedImage:(NSString *)highlightedImage
{
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 32.0, 44.0)];
    customView.backgroundColor = [UIColor clearColor];
    
    UIButton *actionButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(customView.bounds), CGRectGetHeight(customView.bounds))];
    actionButton.backgroundColor = [UIColor clearColor];
    [actionButton setImage:[UIImage imageNamed:XTModulesSDKImage(image)] forState:UIControlStateNormal];
    [actionButton setImage:[UIImage imageNamed:XTModulesSDKImage(highlightedImage)] forState:UIControlStateHighlighted];
    [actionButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:actionButton];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    self.navigationItem.rightBarButtonItems = @[rightButtonItem];
}

- (void)setLeftBarButtonItem:(SEL)action title:(NSString *)title
{
    CGFloat width = [XTAppUtils sizeOfString:title font:XTFont(14.0) constrainedToSize:CGSizeMake(100.0, 44.0)].width;
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, width, 44.0)];
    customView.backgroundColor = [UIColor clearColor];
    
    UIButton *actionButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(customView.bounds), CGRectGetHeight(customView.bounds))];
    actionButton.backgroundColor = [UIColor clearColor];
    actionButton.titleLabel.font = XTFont(14.0);
    [actionButton setTitleColor:XTBrandRedColor forState:UIControlStateNormal];
    [actionButton setTitleColor:[XTBrandRedColor colorWithAlphaComponent:0.8] forState:UIControlStateHighlighted];
    [actionButton setTitle:title forState:UIControlStateNormal];
    [actionButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:actionButton];
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    self.navigationItem.leftBarButtonItems = @[leftButtonItem];
}

- (void)setRightBarButtonItem:(SEL)action title:(NSString *)title
{
    CGFloat width = [XTAppUtils sizeOfString:title font:XTFont(14.0) constrainedToSize:CGSizeMake(100.0, 44.0)].width;
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, width, 44.0)];
    customView.backgroundColor = [UIColor clearColor];
    
    UIButton *actionButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(customView.bounds), CGRectGetHeight(customView.bounds))];
    actionButton.backgroundColor = [UIColor clearColor];
    actionButton.titleLabel.font = XTFont(14.0);
    [actionButton setTitleColor:XTBrandRedColor forState:UIControlStateNormal];
    [actionButton setTitleColor:[XTBrandRedColor colorWithAlphaComponent:0.8] forState:UIControlStateHighlighted];
    [actionButton setTitle:title forState:UIControlStateNormal];
    [actionButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:actionButton];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    self.navigationItem.rightBarButtonItems = @[rightButtonItem];
}

- (void)showAlert:(NSString *)title
{
    [self showAlert:title shouldGoBack:NO];
}

- (void)showAlert:(NSString *)title shouldGoBack:(BOOL)shouldGoBack
{
    _bShouldGoBack = shouldGoBack;
    
    XTAlertView *alertView = [XTAlertView alertViewWithTitle:title message:nil];
    
    [alertView addButtonWithTitle:@"确定" type:XTAlertViewButtonTypeDefault handler:^(XTAlertView *alertView) {
        if (_bShouldGoBack && self.navigationController.viewControllers.count > 1) {
            _bShouldGoBack = NO;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    [alertView show];
}

- (void)showAuthorizationAlert:(NSString *)title
{
    XTAlertView *alertView = [XTAlertView alertViewWithTitle:title message:nil];
    
    [alertView addButtonWithTitle:@"取消" type:XTAlertViewButtonTypeCancel handler:nil];
    [alertView addButtonWithTitle:@"去开启" type:XTAlertViewButtonTypeDefault handler:^(XTAlertView *alertView) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    
    [alertView show];
}

@end

@implementation XTBaseViewController (Loading)

- (BOOL)isLoading
{
    return (_loadingView != nil);
}

- (void)showLoading
{
    if (!_loadingView) {
        _loadingView = [[MBProgressHUD alloc] initWithView:XTMainWindow];
        [XTMainWindow addSubview:_loadingView];
        
        UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 30.0, 30.0)];
        customView.backgroundColor = [UIColor clearColor];
        
        UIImageView *circleImageView = [[UIImageView alloc] initWithFrame:customView.bounds];
        circleImageView.backgroundColor = [UIColor clearColor];
        circleImageView.image = [UIImage imageNamed:XTModulesSDKImage(@"loading_circle")];
        
        [customView addSubview:circleImageView];
        
        NSLayoutConstraint *customViewWidthConstraint = [NSLayoutConstraint constraintWithItem:customView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30.0];
        NSLayoutConstraint *customViewHeightConstraint = [NSLayoutConstraint constraintWithItem:customView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30.0];
        [customView addConstraint:customViewWidthConstraint];
        [customView addConstraint:customViewHeightConstraint];
        
        CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotateAnimation.fromValue = @(0.0);
        rotateAnimation.toValue = @(M_PI * 2);
        rotateAnimation.duration = 1.0;
        rotateAnimation.fillMode = kCAFillModeForwards;
        rotateAnimation.repeatCount = MAXFLOAT;
        [circleImageView.layer addAnimation:rotateAnimation forKey:nil];
        
        _loadingView.minShowTime = 0.5;
        _loadingView.bezelView.color = [UIColor colorWithWhite:0.4 alpha:0.9];
        _loadingView.mode = MBProgressHUDModeCustomView;
        _loadingView.customView = customView;
        _loadingView.delegate = self;
        
        [_loadingView showAnimated:YES];
    }
}

- (void)hideLoading
{
    if (_loadingView) {
        [_loadingView hideAnimated:NO];
    }
}

#pragma mark - MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [_loadingView removeFromSuperview];
    _loadingView = nil;
}

@end

@implementation XTBaseViewController (Toast)

- (void)showToastWithText:(NSString *)text
{
    if (text.length == 0) return;
    
    MBProgressHUD *toastView = [MBProgressHUD showHUDAddedTo:XTMainWindow animated:YES];
    toastView.mode = MBProgressHUDModeText;
    toastView.label.font = [UIFont fontWithName:@"Heiti SC" size:15.0];
    toastView.label.text = text;
    toastView.removeFromSuperViewOnHide = YES;
    
    [toastView hideAnimated:YES afterDelay:1.2];
}

@end
