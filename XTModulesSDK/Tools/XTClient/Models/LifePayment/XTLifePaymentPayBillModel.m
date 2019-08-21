//
//  XTLifePaymentPayBillModel.m
//  XTModulesSDK
//
//  Created by wdd on 2019/8/14.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTLifePaymentPayBillModel.h"

@implementation XTLifePaymentPayBillModel

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"accountNo" : @"payAccountId", @"accountAddress" : @"name", @"companyName" : @"pName", @"balance" : @"balance", @"arrearage" : @"arrearage", @"isInArrears" : @"isArrearage", @"code" : @"code", @"message" : @"message"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    NSArray *optionalProperties = @[@"accountNo", @"accountAddress", @"companyName", @"balance", @"arrearage", @"isInArrears", @"code", @"message"];
    return [optionalProperties containsObject:propertyName];
}

@end
