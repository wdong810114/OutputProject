//
//  XTLifePaymentAccountNoCell.h
//  XTModulesSDK
//
//  Created by wdd on 2019/8/16.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XTLifePaymentAccountNoCell;

@protocol XTLifePaymentAccountNoCellDelegate <NSObject>

@required
- (void)lifePaymentAccountNoCell:(XTLifePaymentAccountNoCell *)lifePaymentAccount didChangeAccountNo:(NSString *)accountNo;

@end

@interface XTLifePaymentAccountNoCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UITextField *noTextField;

@property (nonatomic, weak) id<XTLifePaymentAccountNoCellDelegate> delegate;

@end
