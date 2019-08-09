//
//  XTDefaultClientConfiguration.h
//  XTModulesSDK
//
//  Created by wdd on 2019/7/24.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XTClientConfiguration.h"

@interface XTDefaultClientConfiguration : NSObject <XTClientConfiguration>

@property (nonatomic, copy, readonly) NSString *host;

@property (nonatomic, strong, readonly) NSDictionary *defaultHeaders;

@property (nonatomic, strong) NSTimeZone *serializationTimeZone;

+ (instancetype)sharedConfig;

- (void)setDefaultHeaderValue:(NSString *)value forKey:(NSString *)key;
- (void)removeDefaultHeaderForKey:(NSString *)key;
- (NSString *)defaultHeaderForKey:(NSString *)key;

@end
