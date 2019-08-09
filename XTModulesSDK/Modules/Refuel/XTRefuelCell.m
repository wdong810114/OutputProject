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
    [self.minusButton setImage:[UIImage imageNamed:XTModulesSDKImage(@"count_minus")] forState:UIControlStateNormal];
}

- (IBAction)plusButtonClicked:(UIButton *)sender
{
    self.countPlusBlock();
    
    NSInteger count = [self.countLabel.text integerValue] + 1;
    self.countLabel.text = [NSString stringWithFormat:@"%i", (int)count];
    
    self.minusButton.hidden = NO;
    self.countLabel.hidden = NO;
}

- (IBAction)minusButtonClicked:(UIButton *)sender
{
    self.countMinusBlock();
    
    NSInteger count = [self.countLabel.text integerValue] - 1;
    self.countLabel.text = [NSString stringWithFormat:@"%i", (int)count];
    
    if (count == 0) {
        self.minusButton.hidden = YES;
        self.countLabel.hidden = YES;
    }
}

- (void)setModel:(XTRefuelGoodsModel *)model
{
    _model = model;
    
    self.nameLabel.text = model.goodsName;
    self.amountLabel.text = [NSString stringWithFormat:@"¥ %.2f", [model.amount floatValue]];
}

@end
