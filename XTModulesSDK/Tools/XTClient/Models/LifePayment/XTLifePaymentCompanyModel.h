//
//  XTLifePaymentCompanyModel.h
//  XTModulesSDK
//
//  Created by wdd on 2019/8/14.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTModuleObject.h"

@protocol XTLifePaymentCompanyModel
@end

@interface XTLifePaymentCompanyModel : XTModuleObject

/*
 *  缴费公司编码
 */
@property (nonatomic) NSString *companyCode;
/*
 *  缴费公司名称
 */
@property (nonatomic) NSString *companyName;
/*
 *  缴费公司类型，1：水费 2：电费 3：煤气费
 */
@property (nonatomic) NSString *companyType;

@end
