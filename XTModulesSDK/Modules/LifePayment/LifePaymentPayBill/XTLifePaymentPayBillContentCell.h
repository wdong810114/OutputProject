//
//  XTLifePaymentPayBillContentCell.h
//  XTModulesSDK
//
//  Created by wdd on 2019/8/20.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XTLifePaymentPayBillContentCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *accountAddressLabel;
@property (nonatomic, weak) IBOutlet UILabel *companyNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *arrearageLabel;
@property (nonatomic, weak) IBOutlet UILabel *balanceLabel;

@end
