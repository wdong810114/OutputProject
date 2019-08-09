//
//  XTPhonePriceModel.m
//  XTModulesSDK
//
//  Created by wdd on 2019/7/26.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTPhonePriceModel.h"

@implementation XTPhonePriceModel

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"goodsId" : @"goodId", @"facePrice" : @"facePrice", @"salePrice" : @"salePrice"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    NSArray *optionalProperties = @[@"goodsId", @"facePrice", @"salePrice"];
    return [optionalProperties containsObject:propertyName];
}

@end
