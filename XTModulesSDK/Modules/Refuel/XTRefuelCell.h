//
//  XTRefuelCell.h
//  XTModulesSDK
//
//  Created by wdd on 2019/8/7.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XTRefuelGoodsModel.h"

@interface XTRefuelCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *amountLabel;
@property (nonatomic, weak) IBOutlet UIButton *plusButton;
@property (nonatomic, weak) IBOutlet UILabel *countLabel;
@property (nonatomic, weak) IBOutlet UIButton *minusButton;

- (IBAction)plusButtonClicked:(UIButton *)sender;
- (IBAction)minusButtonClicked:(UIButton *)sender;

@property (nonatomic, copy) void(^countPlusBlock)(void);
@property (nonatomic, copy) void(^countMinusBlock)(void);

@property (nonatomic, strong) XTRefuelGoodsModel *model;

@end
