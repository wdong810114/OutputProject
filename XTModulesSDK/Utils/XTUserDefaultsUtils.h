//
//  XTUserDefaultsUtils.h
//  XTModulesSDK
//
//  Created by wdd on 2019/7/30.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XTUserDefaultsUtils : NSObject

+ (void)setObject:(id)value forKey:(NSString *)defaultName;
+ (id)objectForKey:(NSString *)defaultName;

+ (void)setBool:(BOOL)value forKey:(NSString *)defaultName;
+ (BOOL)boolForKey:(NSString *)defaultName;

+ (void)removeObjectForKey:(NSString *)defaultName;

+ (void)print;

@end
