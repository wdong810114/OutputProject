//
//  XTLifePaymentAccountCell.h
//  XTModulesSDK
//
//  Created by wdd on 2019/8/15.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XTLifePaymentAccountModel.h"

@class XTLifePaymentAccountCell;

@protocol XTLifePaymentAccountCellDelegate <NSObject>

@required
- (void)lifePaymentAccountCellDidClickEdit:(XTLifePaymentAccountCell *)lifePaymentAccountCell;
- (void)lifePaymentAccountCellDidClickDelete:(XTLifePaymentAccountCell *)lifePaymentAccountCell;

@end

@interface XTLifePaymentAccountCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *tagLabel;
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;

@property (nonatomic, weak) id<XTLifePaymentAccountCellDelegate> delegate;

@property (nonatomic, strong) XTLifePaymentAccountModel *model;
@property (nonatomic, assign) BOOL isEditing;

@end
