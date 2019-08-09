//
//  XTPhonePriceButton.m
//  XTModulesSDK
//
//  Created by wdd on 2019/7/30.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTPhonePriceButton.h"

#import "XTMacro.h"

@interface XTPhonePriceButton ()

@property (nonatomic, strong) UILabel *facePriceLabel;
@property (nonatomic, strong) UILabel *salePriceLabel;

@end

@implementation XTPhonePriceButton

- (instancetype)initWithFacePrice:(NSString *)facePrice salePrice:(NSString *)salePrice
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.0;
        self.layer.borderWidth = 1.0;
        
        UILabel *facePriceLabel = [[UILabel alloc] init];
        facePriceLabel.backgroundColor = [UIColor clearColor];
        facePriceLabel.font = XTFont(20.0);
        facePriceLabel.textAlignment = NSTextAlignmentCenter;
        facePriceLabel.text = facePrice;
        self.facePriceLabel = facePriceLabel;
        
        UILabel *salePriceLabel = [[UILabel alloc] init];
        salePriceLabel.backgroundColor = [UIColor clearColor];
        salePriceLabel.font = XTFont(12.0);
        salePriceLabel.textAlignment = NSTextAlignmentCenter;
        salePriceLabel.text = salePrice;
        self.salePriceLabel = salePriceLabel;
        
        [self addSubview:self.facePriceLabel];
        [self addSubview:self.salePriceLabel];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.facePriceLabel.frame = CGRectMake(0.0, 7.0, CGRectGetWidth(self.bounds), 28.0);
    self.salePriceLabel.frame = CGRectMake(0.0, CGRectGetMaxY(self.facePriceLabel.frame) + 6.0, CGRectGetWidth(self.bounds), 20.0);
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    self.backgroundColor = highlighted ? XTBrandBlueColor : [UIColor clearColor];
    self.facePriceLabel.textColor = highlighted ? [UIColor whiteColor] : XTBrandBlueColor;
    self.salePriceLabel.textColor = self.facePriceLabel.textColor;
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    if (enabled) {
        self.layer.borderColor = XTBrandBlueColor.CGColor;
        self.facePriceLabel.textColor = XTBrandBlueColor;
    } else {
        self.layer.borderColor = XTBrandGrayColor.CGColor;
        self.facePriceLabel.textColor = XTBrandGrayColor;
    }
    self.salePriceLabel.textColor = self.facePriceLabel.textColor;
}

@end
