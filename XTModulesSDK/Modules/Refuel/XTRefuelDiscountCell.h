//
//  XTRefuelDiscountCell.h
//  XTModulesSDK
//
//  Created by 王冬冬 on 2019/12/16.
//  Copyright © 2019 Newsky Payment. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XTRefuelGoodsModel.h"

@interface XTRefuelDiscountCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *discountAmountLabel;
@property (nonatomic, weak) IBOutlet UILabel *amountLabel;
@property (nonatomic, weak) IBOutlet UIImageView *discountFlagImageView;
@property (nonatomic, weak) IBOutlet UILabel *discountLabel;
@property (nonatomic, weak) IBOutlet UILabel *limitLabel;
@property (nonatomic, weak) IBOutlet UIButton *plusButton;
@property (nonatomic, weak) IBOutlet UILabel *countLabel;
@property (nonatomic, weak) IBOutlet UIButton *minusButton;

- (IBAction)plusButtonClicked:(UIButton *)sender;
- (IBAction)minusButtonClicked:(UIButton *)sender;

@property (nonatomic, copy) void(^countPlusBlock)(void);
@property (nonatomic, copy) void(^countMinusBlock)(void);

@property (nonatomic, strong) XTRefuelGoodsModel *model;

@end
