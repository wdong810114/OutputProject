//
//  XTLifePaymentAccountModel.m
//  XTModulesSDK
//
//  Created by wdd on 2019/8/13.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTLifePaymentAccountModel.h"

@implementation XTLifePaymentAccountModel

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"uuid" : @"uuid", @"accountType" : @"accountType", @"accountNo" : @"accountNo", @"accountAddress" : @"address", @"tagCode" : @"tagCode", @"tagName" : @"tagName", @"cityCode" : @"cityCode", @"cityName" : @"cityName", @"companyCode" : @"companyCode", @"companyName" : @"companyName"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    NSArray *optionalProperties = @[@"uuid", @"accountType", @"accountNo", @"accountAddress", @"tagCode", @"tagName", @"cityCode", @"cityName", @"companyCode", @"companyName"];
    return [optionalProperties containsObject:propertyName];
}

@end
