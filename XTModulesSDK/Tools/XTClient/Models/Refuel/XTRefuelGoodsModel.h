//
//  XTRefuelGoodsModel.h
//  XTModulesSDK
//
//  Created by wdd on 2019/8/6.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTModuleObject.h"

@protocol XTRefuelGoodsModel
@end

@interface XTRefuelGoodsModel : XTModuleObject

/*
 *  商品ID
 */
@property (nonatomic) NSString *goodsId;
/*
 *  商品名称
 */
@property (nonatomic) NSString *goodsName;
/*
 *  金额
 */
@property (nonatomic) NSString *amount;

@end
