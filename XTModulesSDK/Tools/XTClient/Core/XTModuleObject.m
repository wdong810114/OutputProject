//
//  XTModuleObject.m
//  XTModulesSDK
//
//  Created by wdd on 2019/7/24.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTModuleObject.h"

@implementation XTModuleObject

/**
 * JSONModel多线程问题的解决方案
 * https://github.com/icanzilb/JSONModel/issues/441
 */
- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError **)err
{
    static NSMutableSet *classNames;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        classNames = [NSMutableSet new];
    });
    
    BOOL initSync;
    @synchronized([self class])
    {
        NSString *className = NSStringFromClass([self class]);
        initSync = ![classNames containsObject:className];
        if (initSync) {
            [classNames addObject:className];
            self = [super initWithDictionary:dict error:err];
        }
    }
    if (!initSync) {
        self = [super initWithDictionary:dict error:err];
    }
    return self;
}

- (NSString *)description
{
    return [[self toDictionary] description];
}

@end
