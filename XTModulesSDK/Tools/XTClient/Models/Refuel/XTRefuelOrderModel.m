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
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"orderId" : @"orderId", @"orderAmount" : @"orderAmount", @"createTime" : @"createTime", @"endTime" : @"endTime"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    NSArray *optionalProperties = @[@"orderId", @"orderAmount", @"createTime", @"endTime"];
    return [optionalProperties containsObject:propertyName];
}

@end
