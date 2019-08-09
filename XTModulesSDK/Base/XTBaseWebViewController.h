//
//  XTBaseWebViewController.h
//  XTModulesSDK
//
//  Created by wdd on 2019/8/8.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTBaseViewController.h"

#import <WebKit/WebKit.h>

@interface XTBaseWebViewController : XTBaseViewController <WKNavigationDelegate, WKScriptMessageHandler>

@property (nonatomic, strong, readonly) WKWebView *mainWebView;
@property (nonatomic, strong, readonly) UIProgressView *estimatedProgressView;
@property (nonatomic, copy) NSString *urlString;

@property (nonatomic, assign) BOOL shouldGoBack;
@property (nonatomic, assign) BOOL shouldIgnoreCache;
@property (nonatomic, assign) BOOL shouldShowNetworkUnavailableView;

- (void)configWebView NS_REQUIRES_SUPER;
- (void)startLoadWebView;

@end
