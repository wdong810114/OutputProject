//
//  XTUserDefaultsUtils.m
//  XTModulesSDK
//
//  Created by wdd on 2019/7/30.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTUserDefaultsUtils.h"

@implementation XTUserDefaultsUtils

+ (void)setObject:(id)value forKey:(NSString *)defaultName
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:defaultName];
    [userDefaults synchronize];
}

+ (id)objectForKey:(NSString *)defaultName
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:defaultName];
}

+ (void)setBool:(BOOL)value forKey:(NSString *)defaultName
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:value forKey:defaultName];
    [userDefaults synchronize];
}

+ (BOOL)boolForKey:(NSString *)defaultName
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:defaultName];
}

+ (void)removeObjectForKey:(NSString *)defaultName
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:defaultName];
    [userDefaults synchronize];
}

+ (void)print
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userDefaults dictionaryRepresentation];
    NSLog(@"%@", dict);
}

@end
