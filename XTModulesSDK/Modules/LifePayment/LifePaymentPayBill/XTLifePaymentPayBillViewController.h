//
//  XTLifePaymentPayBillViewController.h
//  XTModulesSDK
//
//  Created by wdd on 2019/8/15.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTBaseViewController.h"

#import "XTLifePaymentConstants.h"
#import "XTLifePaymentAccountModel.h"
#import "XTLifePaymentPayBillModel.h"

@interface XTLifePaymentPayBillViewController : XTBaseViewController

@property (nonatomic, assign) XTLifePaymentType lifePaymentType;

@property (nonatomic, strong) XTLifePaymentAccountModel *accountModel;
@property (nonatomic, strong) XTLifePaymentPayBillModel *payBillModel;

@end
