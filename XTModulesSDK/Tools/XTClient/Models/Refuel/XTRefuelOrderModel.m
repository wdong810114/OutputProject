//
//  XTRefuelOrderModel.m
//  XTModulesSDK
//
//  Created by wdd on 2019/8/8.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTRefuelOrderModel.h"

@implementation XTRefuelOrderModel

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"xtCode" : @"code", @"xtMessage" : @"message", @"orderId" : @"orderId", @"orderAmount" : @"orderAmount", @"originalOrderAmount" : @"orgOrderAmount", @"createTime" : @"createTime", @"endTime" : @"endTime"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    NSArray *optionalProperties = @[@"xtCode", @"xtMessage", @"orderId", @"orderAmount", @"originalOrderAmount", @"createTime", @"endTime"];
    return [optionalProperties containsObject:propertyName];
}

@end
