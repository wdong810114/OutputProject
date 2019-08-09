//
//  XTPhoneRechargeOrderModel.h
//  XTModulesSDK
//
//  Created by wdd on 2019/7/31.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTModuleObject.h"

@protocol XTPhoneRechargeOrderModel
@end

@interface XTPhoneRechargeOrderModel : XTModuleObject

/*
 *  订单ID
 */
@property (nonatomic) NSString *orderId;

@end
