//
//  XTDefaultClientConfiguration.m
//  XTModulesSDK
//
//  Created by wdd on 2019/7/24.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTDefaultClientConfiguration.h"

@interface XTDefaultClientConfiguration ()

@property (nonatomic, strong) NSMutableDictionary *mutableDefaultHeaders;

@end

@implementation XTDefaultClientConfiguration

+ (instancetype)sharedConfig
{
    static XTDefaultClientConfiguration *config = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        config = [[self alloc] init];
    });
    
    return config;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _host = @"http://221.180.167.192/AppExternal/LifeService";
        
        _mutableDefaultHeaders = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (NSDictionary *)defaultHeaders
{
// Added by wangdongdong--Start
    [self setDefaultHeaderValue:@"App Store" forKey:@"channel"];
//    [self setDefaultHeaderValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forKey:@"version"];
//    [self setDefaultHeaderValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:@"build"];
    [self setDefaultHeaderValue:@"1.9.3" forKey:@"version"];
    [self setDefaultHeaderValue:@"2019051701" forKey:@"build"];
    [self setDefaultHeaderValue:@"iOS" forKey:@"platform"];
// Added by wangdongdong--End
    
    return [self.mutableDefaultHeaders copy];
}

#pragma mark - Public
- (void)setDefaultHeaderValue:(NSString *)value forKey:(NSString *)key
{
    if (!value) {
        [self.mutableDefaultHeaders removeObjectForKey:key];
        return;
    }
    self.mutableDefaultHeaders[key] = value;
}

- (void)removeDefaultHeaderForKey:(NSString *)key
{
    [self.mutableDefaultHeaders removeObjectForKey:key];
}

- (NSString *)defaultHeaderForKey:(NSString *)key
{
    return self.mutableDefaultHeaders[key];
}

@end
