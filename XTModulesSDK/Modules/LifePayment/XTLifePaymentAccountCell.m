//
//  XTLifePaymentAccountCell.m
//  XTModulesSDK
//
//  Created by wdd on 2019/8/15.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTLifePaymentAccountCell.h"

#import "XTMacro.h"

@interface XTLifePaymentAccountCell ()

@property (nonatomic, strong) UIView *manageView;

@end

@implementation XTLifePaymentAccountCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.isManaging) {
        self.manageView.frame = CGRectMake(CGRectGetWidth(self.contentView.bounds) - 135.0, 0.0, 135.0, CGRectGetHeight(self.contentView.bounds));
        self.manageView.hidden = NO;
    } else {
        self.manageView.frame = CGRectZero;
        self.manageView.hidden = YES;
    }
}

- (void)setIsManaging:(BOOL)isManaging
{
    _isManaging = isManaging;
    
    if (isManaging) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.contentLabelTrailing.constant = 135.0;
        
        [self.contentView addSubview:self.manageView];
    } else {
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.contentLabelTrailing.constant = 5.0;
        
        [self.manageView removeFromSuperview];
    }
    
    [self setNeedsLayout];
}

- (void)setModel:(XTLifePaymentAccountModel *)model
{
    _model = model;
    
    self.tagLabel.text = model.tagName;
    self.contentLabel.text = model.accountNo;
    if (model.accountAddress.length > 0) {
        self.contentLabel.text = [self.contentLabel.text stringByAppendingString:[NSString stringWithFormat:@" | %@", [model.accountAddress stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"*"]]];
    }
}

#pragma mark - Button
- (void)editButtonClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(lifePaymentAccountCellDidClickEdit:)]) {
        [self.delegate lifePaymentAccountCellDidClickEdit:self];
    }
}

- (void)deleteButtonClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(lifePaymentAccountCellDidClickDelete:)]) {
        [self.delegate lifePaymentAccountCellDidClickDelete:self];
    }
}

#pragma mark - Getter
- (UIView *)manageView
{
    if (!_manageView) {
        _manageView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.contentView.bounds) - 135.0, 0.0, 135.0, CGRectGetHeight(self.contentView.bounds))];
        _manageView.backgroundColor = [UIColor clearColor];
        _manageView.hidden = NO;
        
        UIButton *editButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 67.0, CGRectGetHeight(_manageView.bounds))];
        editButton.backgroundColor = [UIColor clearColor];
        editButton.titleLabel.font = XTFont(14.0);
        [editButton setTitleColor:XTBrandRedColor forState:UIControlStateNormal];
        [editButton setTitleColor:[XTBrandRedColor colorWithAlphaComponent:0.8] forState:UIControlStateHighlighted];
        [editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [editButton addTarget:self action:@selector(editButtonClicked) forControlEvents:UIControlEventTouchUpInside];

        UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(67.0, (CGRectGetHeight(_manageView.bounds) - 20.0) / 2, 1.0, 20.0)];
        divider.backgroundColor = XTBrandRedColor;
        
        UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(68.0, 0.0, 67.0, CGRectGetHeight(_manageView.bounds))];
        deleteButton.backgroundColor = [UIColor clearColor];
        deleteButton.titleLabel.font = XTFont(14.0);
        [deleteButton setTitleColor:XTBrandRedColor forState:UIControlStateNormal];
        [deleteButton setTitleColor:[XTBrandRedColor colorWithAlphaComponent:0.8] forState:UIControlStateHighlighted];
        [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [_manageView addSubview:editButton];
        [_manageView addSubview:divider];
        [_manageView addSubview:deleteButton];
    }
    
    return _manageView;
}

@end
