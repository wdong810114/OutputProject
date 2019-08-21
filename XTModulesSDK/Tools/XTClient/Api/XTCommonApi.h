//
//  XTCommonApi.h
//  XTModulesSDK
//
//  Created by wdd on 2019/7/29.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XTApiClient.h"

@interface XTCommonApi : NSObject

@property (nonatomic, strong) XTApiClient *apiClient;

+ (instancetype)sharedAPI;
- (instancetype)initWithApiClient:(XTApiClient *)apiClient;

@end
