//
//  XTPhoneRechargeOrderModel.m
//  XTModulesSDK
//
//  Created by wdd on 2019/7/31.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTPhoneRechargeOrderModel.h"

@implementation XTPhoneRechargeOrderModel

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"orderId" : @"orderId"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    NSArray *optionalProperties = @[@"orderId"];
    return [optionalProperties containsObject:propertyName];
}

@end
