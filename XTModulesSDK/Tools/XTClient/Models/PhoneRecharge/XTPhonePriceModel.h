//
//  XTPhonePriceModel.h
//  XTModulesSDK
//
//  Created by wdd on 2019/7/26.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTModuleObject.h"

@protocol XTPhonePriceModel
@end

@interface XTPhonePriceModel : XTModuleObject

/*
 *  商品ID
 */
@property (nonatomic) NSString *goodsId;
/*
 *  票面价格（单位元）
 */
@property (nonatomic) NSString *facePrice;
/*
 *  销售价格（单位元）
 */
@property (nonatomic) NSString *salePrice;

@end
