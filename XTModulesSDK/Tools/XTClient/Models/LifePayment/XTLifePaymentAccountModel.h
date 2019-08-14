//
//  XTLifePaymentAccountModel.h
//  XTModulesSDK
//
//  Created by wdd on 2019/8/13.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTModuleObject.h"

@protocol XTLifePaymentAccountModel
@end

@interface XTLifePaymentAccountModel : XTModuleObject

/*
 *  唯一标识
 */
@property (nonatomic) NSString *uuid;
/*
 *  账户类型，1：水费 2：电费 3：煤气费
 */
@property (nonatomic) NSString *accountType;
/*
 *  账户号
 */
@property (nonatomic) NSString *accountNo;
/*
 *  账户地址
 */
@property (nonatomic) NSString *accountAddress;
/*
 *  城市编码
 */
@property (nonatomic) NSString *cityCode;
/*
 *  城市名称
 */
@property (nonatomic) NSString *cityName;
/*
 *  缴费公司编码
 */
@property (nonatomic) NSString *companyCode;
/*
 *  缴费公司名称
 */
@property (nonatomic) NSString *companyName;
/*
 *  标签名称
 */
@property (nonatomic) NSString *tagName;

@end
