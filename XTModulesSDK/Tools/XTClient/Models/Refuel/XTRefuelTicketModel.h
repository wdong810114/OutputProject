//
//  XTRefuelTicketModel.h
//  XTModulesSDK
//
//  Created by wdd on 2019/8/9.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTModuleObject.h"

@protocol XTRefuelTicketModel
@end

@interface XTRefuelTicketModel : XTModuleObject

/*
 *  券ID
 */
@property (nonatomic) NSString *ticketId;
/*
 *  商品名称
 */
@property (nonatomic) NSString *goodsName;
/*
 *  金额
 */
@property (nonatomic) NSString *amount;
/*
 *  有效期
 */
@property (nonatomic) NSString *endTime;
/*
 *  状态，0：未使用 2：已过期 3：已使用 4：未激活
 */
@property (nonatomic) NSString *status;
/*
 *  二维码
 */
@property (nonatomic) NSString *wbmp;
/*
 *  订单ID
 */
@property (nonatomic) NSString *orderId;

@end
