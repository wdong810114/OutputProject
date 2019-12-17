//
//  XTRefuelDiscountCell.m
//  XTModulesSDK
//
//  Created by 王冬冬 on 2019/12/16.
//  Copyright © 2019 Newsky Payment. All rights reserved.
//

#import "XTRefuelDiscountCell.h"

#import "XTMacro.h"

@implementation XTRefuelDiscountCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.iconImageView.image = [UIImage imageNamed:XTModulesSDKImage(@"refuel_icon")];
    self.discountFlagImageView.image = [UIImage imageNamed:XTModulesSDKImage(@"refuel_discount_flag")];
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
    if (count == self.model.numLimit.integerValue) {
        self.plusButton.enabled = NO;
    }
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
    
    // 商品名称和折扣后金额
    self.nameLabel.text = model.goodsName;
    self.discountAmountLabel.text = [NSString stringWithFormat:@"¥ %.2f", [model.discountAmount floatValue]];
    
    // 金额
    self.amountLabel.text = [NSString stringWithFormat:@"¥ %.2f", [model.amount floatValue]];
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.amountLabel.text attributes:@{NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid)}];
    self.amountLabel.attributedText = attributedText;
    
    // 折扣
    NSInteger discount = [model.discount integerValue];
    if (discount % 10 == 0) {
        self.discountLabel.text = [NSString stringWithFormat:@"%i", (int)(discount / 10)];
    } else {
        self.discountLabel.text = [NSString stringWithFormat:@"%.1f", discount / 10.0];
    }
    
    // 库存
    self.limitLabel.text = [NSString stringWithFormat:@"剩余 %@", model.numLimit];
}

@end
