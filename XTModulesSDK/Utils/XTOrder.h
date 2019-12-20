//
//  XTOrder.h
//  XTModulesSDK
//
//  Created by wdd on 2019/8/22.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XTOrder : NSObject

/**
 *  订单类型，0：话费充值 1：特惠加油 2：水费 3：电费 4：燃气费 -1：错误类型
 */
@property (nonatomic, assign) NSInteger orderType;
/**
 *  订单ID
 */
@property (nonatomic, copy) NSString *orderId;
/**
 *  订单金额（元）
 */
@property (nonatomic, copy) NSString *orderAmount;
/**
 *  订单原始金额（元）
 */
@property (nonatomic, copy) NSString *originalOrderAmount;

/**
 *  订单对象转字典
 */
- (NSDictionary *)toDictionary;

@end
