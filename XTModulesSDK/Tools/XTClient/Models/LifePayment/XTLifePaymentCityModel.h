//
//  XTLifePaymentCityModel.h
//  XTModulesSDK
//
//  Created by wdd on 2019/8/14.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTModuleObject.h"

@protocol XTLifePaymentCityModel
@end

@interface XTLifePaymentCityModel : XTModuleObject

/*
 *  城市编码
 */
@property (nonatomic) NSString *cityCode;
/*
 *  城市名称
 */
@property (nonatomic) NSString *cityName;

@end
