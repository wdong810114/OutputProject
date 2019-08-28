//
//  XTLifePaymentErrorAlertView.m
//  XTModulesSDK
//
//  Created by wdd on 2019/8/28.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTLifePaymentErrorAlertView.h"

#import "XTMacro.h"
#import "XTAppUtils.h"

@interface XTLifePaymentErrorAlertView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation XTLifePaymentErrorAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;
        
        UIView *translucentView = [[UIView alloc] initWithFrame:self.bounds];
        translucentView.backgroundColor = [UIColor blackColor];
        translucentView.alpha = 0.5;
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.bounds) - 280.0) / 2, (CGRectGetHeight(self.bounds) - 210.0) / 2, 280.0, 210.0)];
        contentView.backgroundColor = [UIColor whiteColor];
        contentView.layer.masksToBounds = YES;
        contentView.layer.cornerRadius = 5.0;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 0.0, CGRectGetWidth(contentView.bounds) - 20.0 * 2, 40.0)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = XTFont(14.0);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = XTColorFromHex(0x333333);
        self.titleLabel = titleLabel;
        
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(titleLabel.frame), CGRectGetWidth(contentView.bounds), 1.0)];
        separator.backgroundColor = XTColorFromHex(0xEDEDED);
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(contentView.bounds) - 50.0) / 2, CGRectGetMaxY(separator.frame) + 24.0, 50.0, 50.0)];
        iconImageView.backgroundColor = [UIColor clearColor];
        self.iconImageView = iconImageView;
        
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, CGRectGetMaxY(iconImageView.frame), CGRectGetWidth(contentView.bounds) - 20.0 * 2, 55.0)];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.numberOfLines = 2;
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        messageLabel.font = XTFont(12.0);
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.textColor = XTColorFromHex(0xCCCCCC);
        self.messageLabel = messageLabel;
        
        UIButton *knowButton = [XTAppUtils redButtonWithFrame:CGRectMake(0.0, CGRectGetHeight(contentView.bounds) - 40.0, CGRectGetWidth(contentView.bounds), 40.0)];
        knowButton.titleLabel.font = XTFont(14.0);
        [knowButton setTitle:@"我知道了" forState:UIControlStateNormal];
        [knowButton addTarget:self action:@selector(knowButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [contentView addSubview:titleLabel];
        [contentView addSubview:separator];
        [contentView addSubview:iconImageView];
        [contentView addSubview:messageLabel];
        [contentView addSubview:knowButton];
        
        [self addSubview:translucentView];
        [self addSubview:contentView];
    }
    
    return self;
}

- (void)knowButtonClicked
{
    [self hide];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(lifePaymentErrorAlertViewDidClickKnow:)]) {
        [self.delegate lifePaymentErrorAlertViewDidClickKnow:self];
    }
}

- (void)hide
{
    [UIView animateWithDuration:0.25 animations:^{
        self.hidden = YES;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Setter
- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    
    self.titleLabel.text = title;
}

- (void)setMessage:(NSString *)message
{
    _message = [message copy];
    
    self.messageLabel.text = message;
}

- (void)setIconImage:(UIImage *)iconImage
{
    _iconImage = iconImage;
    
    self.iconImageView.image = iconImage;
}

#pragma mark - Public
- (void)show
{
    [XTMainWindow addSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.hidden = NO;
    }];
}

@end
