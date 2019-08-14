//
//  XTLifePaymentPayBillModel.h
//  XTModulesSDK
//
//  Created by wdd on 2019/8/14.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTModuleObject.h"

@protocol XTLifePaymentPayBillModel
@end

@interface XTLifePaymentPayBillModel : XTModuleObject

/*
 *  账户号
 */
@property (nonatomic) NSString *accountNo;
/*
 *  账户地址
 */
@property (nonatomic) NSString *accountAddress;
/*
 *  缴费公司名称
 */
@property (nonatomic) NSString *companyName;
/*
 *  余额
 */
@property (nonatomic) NSString *balance;
/*
 *  欠费金额
 */
@property (nonatomic) NSString *arrearage;
/*
 *  是否欠费
 */
@property (nonatomic) NSString *isInArrears;

@end
