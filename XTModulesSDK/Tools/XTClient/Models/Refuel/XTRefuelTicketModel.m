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
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ticketId" : @"OIARID", @"ticketName" : @"GOODNAME", @"amount" : @"AMOUNT", @"endTime" : @"ENDTIME", @"status" : @"STATUS", @"wbmp" : @"WBMP", @"orderId" : @"ORDERID", @"usedTime" : @"USE_TIME", @"usedStation" : @"USE_ADDRESS"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    NSArray *optionalProperties = @[@"ticketId", @"ticketName", @"amount", @"endTime", @"status", @"wbmp", @"orderId", @"usedTime", @"usedStation"];
    return [optionalProperties containsObject:propertyName];
}

@end
