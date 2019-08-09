//
//  XTRefuelOrderModel.h
//  XTModulesSDK
//
//  Created by wdd on 2019/8/8.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTModuleObject.h"

@protocol XTRefuelOrderModel
@end

@interface XTRefuelOrderModel : XTModuleObject

/*
 *  订单ID
 */
@property (nonatomic) NSString *orderId;
/*
 *  订单金额（元）
 */
@property (nonatomic) NSString *orderAmount;
/*
 *  生成时间
 */
@property (nonatomic) NSString *createTime;
/*
 *  截止时间
 */
@property (nonatomic) NSString *endTime;

@end
