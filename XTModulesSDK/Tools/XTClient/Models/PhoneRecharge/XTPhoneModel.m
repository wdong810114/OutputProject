//
//  XTPhoneModel.m
//  XTModulesSDK
//
//  Created by wdd on 2019/7/26.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTPhoneModel.h"

@implementation XTPhoneModel

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"code" : @"code", @"isp" : @"isp", @"provinceName" : @"provinceName", @"phoneGoods" : @"phoneGoods"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    NSArray *optionalProperties = @[@"code", @"isp", @"provinceName", @"phoneGoods"];
    return [optionalProperties containsObject:propertyName];
}

@end
