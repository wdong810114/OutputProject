//
//  XTLifePaymentCityListViewController.h
//  XTModulesSDK
//
//  Created by wdd on 2019/8/20.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTBaseViewController.h"

#import "XTLifePaymentConstants.h"
#import "XTLifePaymentCityModel.h"

@class XTLifePaymentCityListViewController;

@protocol XTLifePaymentCityListViewControllerDelegate <NSObject>

@required
- (void)lifePaymentCityListViewController:(XTLifePaymentCityListViewController *)lifePaymentCityListViewController didSelectCityModel:(XTLifePaymentCityModel *)cityModel;

@end

@interface XTLifePaymentCityListViewController : XTBaseViewController

@property (nonatomic, weak) id<XTLifePaymentCityListViewControllerDelegate> delegate;

@property (nonatomic, assign) XTLifePaymentType lifePaymentType;

@end
