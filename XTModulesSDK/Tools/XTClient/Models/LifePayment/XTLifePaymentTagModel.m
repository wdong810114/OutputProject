//
//  XTLifePaymentTagModel.m
//  XTModulesSDK
//
//  Created by wdd on 2019/8/14.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTLifePaymentTagModel.h"

@implementation XTLifePaymentTagModel

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"tagCode" : @"tagCode", @"tagName" : @"tagName"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    NSArray *optionalProperties = @[@"tagCode", @"tagName"];
    return [optionalProperties containsObject:propertyName];
}

@end
