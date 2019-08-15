//
//  XTLifePaymentAccountViewController.h
//  XTModulesSDK
//
//  Created by wdd on 2019/8/15.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTBaseViewController.h"

#import "XTLifePaymentConstants.h"
#import "XTLifePaymentAccountModel.h"

@interface XTLifePaymentAccountViewController : XTBaseViewController

@property (nonatomic, assign) XTLifePaymentType lifePaymentType;

@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) XTLifePaymentAccountModel *accountModel;

@end
