//
//  XTLifePaymentCityModel.m
//  XTModulesSDK
//
//  Created by wdd on 2019/8/14.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTLifePaymentCityModel.h"

@implementation XTLifePaymentCityModel

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"cityCode" : @"cityCode", @"cityName" : @"cityName"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    NSArray *optionalProperties = @[@"cityCode", @"cityName"];
    return [optionalProperties containsObject:propertyName];
}

@end
