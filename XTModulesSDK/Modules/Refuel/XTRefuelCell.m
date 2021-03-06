//
//  XTRefuelCell.m
//  XTModulesSDK
//
//  Created by wdd on 2019/8/7.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTRefuelCell.h"

#import "XTMacro.h"

@implementation XTRefuelCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.iconImageView.image = [UIImage imageNamed:XTModulesSDKImage(@"refuel_icon")];
    [self.plusButton setImage:[UIImage imageNamed:XTModulesSDKImage(@"count_plus")] forState:UIControlStateNormal];
    [self.plusButton setImage:[UIImage imageNamed:XTModulesSDKImage(@"count_plus_disable")] forState:UIControlStateDisabled];
    [self.minusButton setImage:[UIImage imageNamed:XTModulesSDKImage(@"count_minus")] forState:UIControlStateNormal];
    [self.minusButton setImage:[UIImage imageNamed:XTModulesSDKImage(@"count_minus_disable")] forState:UIControlStateDisabled];
}

#pragma mark - Action
- (IBAction)plusButtonClicked:(UIButton *)sender
{
    self.countPlusBlock();
    
    NSInteger count = [self.countLabel.text integerValue] + 1;
    self.countLabel.text = [NSString stringWithFormat:@"%i", (int)count];
    
    self.minusButton.enabled = YES;
}

- (IBAction)minusButtonClicked:(UIButton *)sender
{
    self.countMinusBlock();
    
    NSInteger count = [self.countLabel.text integerValue] - 1;
    self.countLabel.text = [NSString stringWithFormat:@"%i", (int)count];
    
    self.plusButton.enabled = YES;
    if (count == 0) {
        self.minusButton.enabled = NO;
    }
}

#pragma mark - Setter
- (void)setModel:(XTRefuelGoodsModel *)model
{
    _model = model;
    
    // 商品名称和金额
    self.nameLabel.text = model.goodsName;
    self.amountLabel.text = [NSString stringWithFormat:@"¥ %.2f", [model.amount floatValue]];
}

@end
