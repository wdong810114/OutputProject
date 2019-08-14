//
//  XTLifePaymentTagModel.h
//  XTModulesSDK
//
//  Created by wdd on 2019/8/14.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTModuleObject.h"

@protocol XTLifePaymentTagModel
@end

@interface XTLifePaymentTagModel : XTModuleObject

/*
 *  标签编码
 */
@property (nonatomic) NSString *tagCode;
/*
 *  标签名称
 */
@property (nonatomic) NSString *tagName;

@end
