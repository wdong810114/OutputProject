//
//  XTCommonApi.m
//  XTModulesSDK
//
//  Created by wdd on 2019/7/29.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTCommonApi.h"

@implementation XTCommonApi

+ (instancetype)sharedAPI
{
    static XTCommonApi *sharedApi;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedApi = [[self alloc] init];
    });
    
    return sharedApi;
}

- (instancetype)init
{
    return [self initWithApiClient:[XTApiClient sharedClient]];
}

- (instancetype)initWithApiClient:(XTApiClient *)apiClient
{
    self = [super init];
    if (self) {
        _apiClient = apiClient;
    }
    
    return self;
}

@end
