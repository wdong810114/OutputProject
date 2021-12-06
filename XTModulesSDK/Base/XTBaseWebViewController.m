//
//  XTBaseWebViewController.m
//  XTModulesSDK
//
//  Created by wdd on 2019/8/8.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTBaseWebViewController.h"

#import "XTReachability.h"

@interface XTBaseWebViewController ()

@property (nonatomic, strong) WKWebView *mainWebView;
@property (nonatomic, strong) UIProgressView *estimatedProgressView;

@property (nonatomic, strong) UIView *networkUnavailableView;

@property (nonatomic, strong) XTReachability *reachable;

- (void)startRequest;
- (void)handleNetworkUnavailable;

- (BOOL)isReachable;

@end

@implementation XTBaseWebViewController

- (void)dealloc
{
    [self.mainWebView removeObserver:self forKeyPath:@"title"];
    [self.mainWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    
    [self.mainWebView.configuration.userContentController removeScriptMessageHandlerForName:@"tokenError"];
    
    [XTNotificationCenter removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.shouldGoBack = YES;
        self.shouldIgnoreCache = NO;
        self.shouldShowNetworkUnavailableView = NO;
        
        self.reachable = [XTReachability reachabilityForInternetConnection];
        
        [XTNotificationCenter addObserver:self
                                 selector:@selector(reachabilityChanged)
                                     name:kXTReachabilityChangedNotification
                                   object:nil];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setLeftBarButtonItem:@selector(backButtonClicked) image:@"back_icon_n" highlightedImage:@"back_icon_h"];
    
    [self.view addSubview:self.mainWebView];
    [self.view addSubview:self.estimatedProgressView];
    [self.view addSubview:self.networkUnavailableView];
    
    [self configWebView];
    [self startLoadWebView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.reachable startNotifier];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.reachable stopNotifier];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey, id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"title"]) {
        self.title = self.mainWebView.title;
    } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.estimatedProgressView.alpha = 1.0;
        BOOL animated = (self.mainWebView.estimatedProgress > self.estimatedProgressView.progress);
        [self.estimatedProgressView setProgress:self.mainWebView.estimatedProgress animated:animated];
        
        if (self.estimatedProgressView.progress == 1.0) {
            [UIView animateWithDuration:0.25 delay:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.estimatedProgressView.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.estimatedProgressView.progress = 0.0;
            }];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Button
- (void)backButtonClicked
{
    if (self.shouldGoBack && [self.mainWebView canGoBack]) {
        [self.mainWebView goBack];
    } else {
        [self.mainWebView stopLoading];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)reloadButtonClicked
{
    if ([self isReachable]) {
        self.networkUnavailableView.hidden = YES;
        [self.view sendSubviewToBack:self.networkUnavailableView];
        
        [self startRequest];
    }
}

#pragma mark - Notification
- (void)reachabilityChanged
{
    if (self.mainWebView.isLoading && ![self isReachable]) {
        [self.mainWebView stopLoading];
        [self handleNetworkUnavailable];
    }
}

#pragma mark - Public
- (void)configWebView
{
    [self.mainWebView.configuration.userContentController addScriptMessageHandler:self name:@"tokenError"];
}

- (void)startLoadWebView
{
    if ([self isReachable]) {
        [self startRequest];
    } else {
        [self handleNetworkUnavailable];
    }
}

#pragma mark - Private
- (void)startRequest
{
    if (self.urlString) {
        NSURLRequest *request = nil;
        
        if (self.shouldIgnoreCache) {
            request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
        } else {
            request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
        }
        
        NSLog(@"request: %@", request);
        
        [self.mainWebView loadRequest:request];
    }
}

- (void)handleNetworkUnavailable
{
    if (self.shouldShowNetworkUnavailableView) {
        [self.view bringSubviewToFront:self.networkUnavailableView];
        self.networkUnavailableView.hidden = NO;
    } else {
        [self showToastWithText:XTNetworkUnavailable];
    }
}

- (BOOL)isReachable
{
    return ([self.reachable currentReachabilityStatus] != XTNotReachable);
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    if ([navigationResponse.response isKindOfClass:[NSHTTPURLResponse class]]) {
        if (((NSHTTPURLResponse *)navigationResponse.response).statusCode >= 500) {
            // 服务器错误
            [self handleNetworkUnavailable];
            
            decisionHandler(WKNavigationResponsePolicyCancel);
            return;
        }
    }
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *URL = navigationAction.request.URL;
    if ([URL.absoluteString hasPrefix:@"tel:"] ||
       [URL.absoluteString hasPrefix:@"baidumap://"] ||
       [URL.absoluteString hasPrefix:@"itms-appss://"]) {
        // tel：拨打电话
        // baidumap：百度地图
        // itms-appss：App Store
        if ([[UIApplication sharedApplication] canOpenURL:URL]) {
            [[UIApplication sharedApplication] openURL:URL];
            
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:@"tokenError"]) {
        id object = [XTModulesManager sharedManager].sourceVC;
        [XTNotificationCenter postNotificationName:XTUserTokenInvalidNotification object:object];
    } else {
    }
}

#pragma mark - Getter
- (WKWebView *)mainWebView
{
    if (!_mainWebView) {
        _mainWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, XTMainScreenWidth, XTNonTopLevelViewHeight)];
        _mainWebView.backgroundColor = [UIColor clearColor];
        _mainWebView.navigationDelegate = self;
        [_mainWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
        [_mainWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return _mainWebView;
}

- (UIProgressView *)estimatedProgressView
{
    if (!_estimatedProgressView) {
        _estimatedProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0.0, 0.0, XTMainScreenWidth, 2.0)];
        _estimatedProgressView.backgroundColor = [UIColor clearColor];
        _estimatedProgressView.progressTintColor = XTBrandRedColor;
        _estimatedProgressView.trackTintColor = [UIColor clearColor];
        _estimatedProgressView.transform = CGAffineTransformMakeScale(1.0, 1.5);
        _estimatedProgressView.alpha = 0.0;
    }
    
    return _estimatedProgressView;
}

- (UIView *)networkUnavailableView
{
    if (!_networkUnavailableView) {
        _networkUnavailableView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, XTMainScreenWidth, XTNonTopLevelViewHeight)];
        _networkUnavailableView.backgroundColor = XTViewBGColor;
        _networkUnavailableView.hidden = YES;
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, (CGRectGetHeight(_networkUnavailableView.bounds) - 295.0) / 2, CGRectGetWidth(_networkUnavailableView.bounds), 295.0)];
        contentView.backgroundColor = [UIColor clearColor];
        
        UIImageView *sorryImageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(contentView.bounds) - 160.0) / 2, 0.0, 160.0, 200.0)];
        sorryImageView.backgroundColor = [UIColor clearColor];
        sorryImageView.image = [UIImage imageNamed:XTModulesSDKImage(@"network_unavailable")];
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(sorryImageView.frame) + 10.0, CGRectGetWidth(contentView.bounds), 20.0)];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.font = XTFont(14.0);
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.textColor = XTBrandLightBlackColor;
        tipLabel.text = @"网络无法连接";
        
        UIButton *reloadButton = [XTAppUtils redButtonWithFrame:CGRectMake((CGRectGetWidth(contentView.bounds) - 100.0) / 2, CGRectGetMaxY(tipLabel.frame) + 20.0, 100.0, 45.0)];
        reloadButton.titleLabel.font = XTFont(16.0);
        [reloadButton setTitle:@"重新加载" forState:UIControlStateNormal];
        [reloadButton addTarget:self action:@selector(reloadButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [contentView addSubview:sorryImageView];
        [contentView addSubview:tipLabel];
        [contentView addSubview:reloadButton];
        [_networkUnavailableView addSubview:contentView];
    }
    
    return _networkUnavailableView;
}

@end
