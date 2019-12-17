//
//  XTRefuelGoodsModel.m
//  XTModulesSDK
//
//  Created by wdd on 2019/8/6.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTRefuelGoodsModel.h"

@implementation XTRefuelGoodsModel

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"goodsId" : @"goodId", @"goodsName" : @"goodName", @"amount" : @"amount", @"discountAmount" : @"discountAmount", @"discount" : @"discount", @"numLimit" : @"numLimit"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    NSArray *optionalProperties = @[@"goodsId", @"goodsName", @"amount", @"discountAmount", @"discount", @"numLimit"];
    return [optionalProperties containsObject:propertyName];
}

@end
