//
//  XTOrder.m
//  XTModulesSDK
//
//  Created by wdd on 2019/8/22.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTOrder.h"

@implementation XTOrder

- (instancetype)init
{
    self = [super init];
    if (self) {
        _orderType = -1;
    }
    
    return self;
}

- (NSDictionary *)toDictionary
{
    if (self.orderType == -1 || !self.orderId || !self.orderAmount) {
        return nil;
    }
    
    if (!self.originalOrderAmount) {
        self.originalOrderAmount = [self.orderAmount copy];
    }
    
    return @{@"orderType" : @(self.orderType), @"orderId" : self.orderId, @"orderAmount" : self.orderAmount, @"originalOrderAmount" : self.originalOrderAmount};
}

@end
