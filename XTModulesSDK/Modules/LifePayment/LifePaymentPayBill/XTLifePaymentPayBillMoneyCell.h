//
//  XTLifePaymentPayBillMoneyCell.h
//  XTModulesSDK
//
//  Created by wdd on 2019/8/20.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XTLifePaymentPayBillMoneyCell;

@protocol XTLifePaymentPayBillMoneyCellDelegate <NSObject>

@required
- (void)lifePaymentPayBillMoneyCell:(XTLifePaymentPayBillMoneyCell *)lifePaymentPayBillMoneyCell didChangeMoney:(NSString *)money;

@end

@interface XTLifePaymentPayBillMoneyCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UITextField *moneyTextField;

@property (nonatomic, weak) id<XTLifePaymentPayBillMoneyCellDelegate> delegate;

@end
