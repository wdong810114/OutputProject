//
//  XTRefuelTicketModel.m
//  XTModulesSDK
//
//  Created by wdd on 2019/8/9.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTRefuelTicketModel.h"

@implementation XTRefuelTicketModel

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ticketId" : @"oiarId", @"goodsName" : @"goodName", @"amount" : @"amount", @"endTime" : @"endTime", @"status" : @"status", @"wbmp" : @"wbmp", @"orderId" : @"orderId"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    NSArray *optionalProperties = @[@"ticketId", @"goodsName", @"amount", @"endTime", @"status", @"wbmp", @"orderId"];
    return [optionalProperties containsObject:propertyName];
}

@end
