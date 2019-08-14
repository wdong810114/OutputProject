//
//  XTLifePaymentCompanyModel.m
//  XTModulesSDK
//
//  Created by wdd on 2019/8/14.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTLifePaymentCompanyModel.h"

@implementation XTLifePaymentCompanyModel

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"companyCode" : @"companyCode", @"companyName" : @"companyName", @"companyType" : @"companyType"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    NSArray *optionalProperties = @[@"companyCode", @"companyName", @"companyType"];
    return [optionalProperties containsObject:propertyName];
}

@end
