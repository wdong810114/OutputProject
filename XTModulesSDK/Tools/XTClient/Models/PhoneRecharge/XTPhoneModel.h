//
//  XTPhoneModel.h
//  XTModulesSDK
//
//  Created by wdd on 2019/7/26.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTModuleObject.h"
#import "XTPhonePriceModel.h"

@protocol XTPhoneModel
@end

@interface XTPhoneModel : XTModuleObject

/*
 *  新天返回码
 */
@property (nonatomic) NSString *code;
/*
 *  互联网服务供应商：移动/联通/电信
 */
@property (nonatomic) NSString *isp;
/*
 *  手机号归属地
 */
@property (nonatomic) NSString *provinceName;
/*
 *  话费列表
 */
@property (nonatomic) NSArray<XTPhonePriceModel> *phoneGoods;

@end
