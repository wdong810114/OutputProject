//
//  XTLifePaymentOrderModel.h
//  XTModulesSDK
//
//  Created by wdd on 2019/8/14.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTModuleObject.h"

@protocol XTLifePaymentOrderModel
@end

@interface XTLifePaymentOrderModel : XTModuleObject

/*
 *  订单ID
 */
@property (nonatomic) NSString *orderId;

@end
