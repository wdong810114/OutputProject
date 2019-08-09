//
//  XTRoundCornerCell.m
//  XTModulesSDK
//
//  Created by wdd on 2019/8/6.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTRoundCornerCell.h"

#import "XTMacro.h"

NSString * XTRoundCornerCellIdentifier = @"XTRoundCornerCellIdentifier";

@interface XTRoundCornerCell ()

@property (nonatomic, strong) UIImageView *shadowImageView;
@property (nonatomic, strong) UIView *separatorView;

@end

@implementation XTRoundCornerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _roundCornerCellType = XTRoundCornerCellTypeSingle;
        
        _shadowHidden = NO;
        _separatorHidden = NO;
        
        [self addSubview:self.shadowImageView];
        [self addSubview:self.separatorView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIImage *shadowImage = nil;
    
    switch (self.roundCornerCellType) {
        case XTRoundCornerCellTypeSingle:
            shadowImage = [UIImage imageNamed:XTModulesSDKResource(@"XTRoundCornerCell.bundle/cell_shadow_single")];
            break;
        case XTRoundCornerCellTypeTop:
            shadowImage = [UIImage imageNamed:XTModulesSDKResource(@"XTRoundCornerCell.bundle/cell_shadow_top")];
            break;
        case XTRoundCornerCellTypeMiddle:
            shadowImage = [UIImage imageNamed:XTModulesSDKResource(@"XTRoundCornerCell.bundle/cell_shadow_middle")];
            break;
        case XTRoundCornerCellTypeBottom:
            shadowImage = [UIImage imageNamed:XTModulesSDKResource(@"XTRoundCornerCell.bundle/cell_shadow_bottom")];
            break;
            
        default:
            break;
    }
    
    if (!self.shadowHidden && shadowImage) {
        self.shadowImageView.image = [shadowImage resizableImageWithCapInsets:UIEdgeInsetsMake(20.0, 50.0, 20.0, 50.0) resizingMode:UIImageResizingModeStretch];
        self.shadowImageView.frame = CGRectInset(self.bounds, 15.0 - XTCellShadowMarginHorizontal, 0.0);
        
        if (XTRoundCornerCellTypeSingle == self.roundCornerCellType ||
           XTRoundCornerCellTypeBottom == self.roundCornerCellType) {
            self.separatorView.frame = CGRectZero;
        } else {
            self.separatorView.frame = CGRectMake(15.0, CGRectGetHeight(self.bounds) - 0.5, CGRectGetWidth(self.bounds) - 15.0 * 2, 0.5);
        }
    } else {
        self.shadowImageView.image = nil;
        self.shadowImageView.frame = CGRectZero;
        
        self.separatorView.frame = CGRectMake(0.0, CGRectGetHeight(self.bounds) - 0.5, CGRectGetWidth(self.bounds), 0.5);
    }
}

#pragma mark - Setter
- (void)setRoundCornerCellType:(XTRoundCornerCellType)roundCornerCellType
{
    _roundCornerCellType = roundCornerCellType;
    
    if (XTRoundCornerCellTypeSingle == roundCornerCellType ||
       XTRoundCornerCellTypeBottom == roundCornerCellType) {
        self.separatorView.alpha = 0.0;
    } else {
        self.separatorView.alpha = 1.0;
    }
    
    [self setNeedsLayout];
}

- (void)setShadowHidden:(BOOL)shadowHidden
{
    _shadowHidden = shadowHidden;
    
    self.shadowImageView.hidden = shadowHidden;
    
    [self setNeedsLayout];
}

- (void)setSeparatorHidden:(BOOL)separatorHidden
{
    _separatorHidden = separatorHidden;
    
    self.separatorView.hidden = separatorHidden;
}

#pragma mark - Getter
- (UIImageView *)shadowImageView
{
    if (!_shadowImageView) {
        _shadowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _shadowImageView.backgroundColor = [UIColor clearColor];
    }
    
    return _shadowImageView;
}

- (UIView *)separatorView
{
    if (!_separatorView) {
        _separatorView = [[UIView alloc] initWithFrame:CGRectZero];
        _separatorView.backgroundColor = XTSeparatorColor;
    }
    
    return _separatorView;
}

@end
