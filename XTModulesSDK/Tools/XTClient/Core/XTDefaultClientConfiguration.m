//
//  XTDefaultClientConfiguration.m
//  XTModulesSDK
//
//  Created by wdd on 2019/7/24.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTDefaultClientConfiguration.h"

#import "XTMacro.h"
#import "XTModulesManager.h"

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
#if XTIsModulesOutput
        _host = [XTModulesManager sharedManager].host;
#else
        _host = @"http://221.180.167.192/AppExternal/LifeService";
#endif
        
        _mutableDefaultHeaders = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (NSDictionary *)defaultHeaders
{
#if XTIsModulesOutput
    [self setDefaultHeaderValue:@"App Store" forKey:@"channel"];
    [self setDefaultHeaderValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forKey:@"version"];
    [self setDefaultHeaderValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:@"build"];
    [self setDefaultHeaderValue:@"iOS" forKey:@"platform"];
#endif
    
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
