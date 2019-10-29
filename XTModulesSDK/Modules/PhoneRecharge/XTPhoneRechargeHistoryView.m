//
//  XTPhoneRechargeHistoryView.m
//  XTModulesSDK
//
//  Created by wdd on 2019/7/30.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTPhoneRechargeHistoryView.h"

#import "XTMacro.h"
#import "XTUserDefaultsUtils.h"
#import "UIView+XTExtension.h"

NSString * const XTPhoneRechargeHistoryUserDefaultsKey = @"XTPhoneRechargeHistoryUserDefaultsKey";
NSInteger const XTPhoneRechargeHistoryMaxCount = 5;

@interface XTPhoneRechargeHistoryView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *translucentView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITableView *historyTableView;
@property (nonatomic, strong) UIButton *clearButton;
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation XTPhoneRechargeHistoryView
{
    NSMutableArray *_historyArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 加载话费充值历史数据
        [self loadHistory];
        
        // 半透明视图
        UIView *translucentView = [[UIView alloc] initWithFrame:self.bounds];
        translucentView.backgroundColor = [UIColor blackColor];
        translucentView.alpha = 0.5;
        translucentView.hidden = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelSelect)];
        [translucentView addGestureRecognizer:tapGesture];
        self.translucentView = translucentView;
        [self addSubview:self.translucentView];
        
        // 内容视图
        CGFloat keyboardHeight = 216.0;
        CGFloat spaceHeight = 45.0;
        CGFloat clearButtonHeight = 45.0;
        CGFloat bottomLineHeight = 1.0;
        CGFloat contentViewHeight = MIN(_historyArray.count * 45.0 + clearButtonHeight + bottomLineHeight, CGRectGetHeight(self.bounds) - keyboardHeight - spaceHeight);
        CGFloat historyTableViewHeight = contentViewHeight - clearButtonHeight - bottomLineHeight;
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.bounds), contentViewHeight)];
        contentView.backgroundColor = [UIColor whiteColor];
        contentView.hidden = YES;
        self.contentView = contentView;
        [self addSubview:self.contentView];
        
        UITableView *historyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.contentView.bounds), historyTableViewHeight) style:UITableViewStylePlain];
        historyTableView.backgroundColor = [UIColor clearColor];
        historyTableView.separatorColor = XTSeparatorColor;
        historyTableView.dataSource = self;
        historyTableView.delegate = self;
        historyTableView.tableFooterView = [[UIView alloc] init];
        if (XTDeviceSystemVersion >= 11.0) {
            historyTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        self.historyTableView = historyTableView;
        
        UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(self.historyTableView.frame), CGRectGetWidth(self.contentView.bounds), clearButtonHeight)];
        clearButton.backgroundColor = [UIColor clearColor];
        [clearButton setTitleColor:XTBrandGrayColor forState:UIControlStateNormal];
        [clearButton setTitle:@"清空历史记录" forState:UIControlStateNormal];
        [clearButton addTarget:self action:@selector(clearHistory) forControlEvents:UIControlEventTouchUpInside];
        self.clearButton = clearButton;
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(self.clearButton.frame), CGRectGetWidth(self.contentView.bounds), bottomLineHeight)];
        bottomLine.backgroundColor = XTSeparatorColor;
        self.bottomLine = bottomLine;

        [self.contentView addSubview:self.historyTableView];
        [self.contentView addSubview:self.clearButton];
        [self.contentView addSubview:self.bottomLine];
        
        self.hidden = YES;
    }
    
    return self;
}

- (void)show
{
    self.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.translucentView.hidden = NO;
        if (_historyArray.count > 0) {
            self.contentView.hidden = NO;
        }
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.25 animations:^{
        self.translucentView.hidden = YES;
        if (_historyArray.count > 0) {
            self.contentView.hidden = YES;
        }
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

+ (void)addHistoryWithPhoneNumber:(NSString *)phoneNumber name:(NSString *)name detail:(NSString *)detail
{
    if (!phoneNumber) {
        return;
    }
    
    NSArray *defaultHistoryArray = [XTUserDefaultsUtils objectForKey:XTPhoneRechargeHistoryUserDefaultsKey];
    if (!defaultHistoryArray) {
        defaultHistoryArray = [NSArray array];
    }
    
    NSMutableArray *historyArray = [NSMutableArray arrayWithArray:defaultHistoryArray];
    [historyArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        if ([phoneNumber isEqualToString:dict[@"PhoneNumber"]]) {
            [historyArray removeObjectAtIndex:idx];
            *stop = YES;
        }
    }];
    
    [historyArray insertObject:@{@"PhoneNumber" : phoneNumber,
                                 @"Name" : (name ? name : @""),
                                 @"Detail" : (detail ? detail : @"")} atIndex:0];
    
    if (historyArray.count > XTPhoneRechargeHistoryMaxCount) {
        [historyArray removeObjectsInRange:NSMakeRange(XTPhoneRechargeHistoryMaxCount, historyArray.count - XTPhoneRechargeHistoryMaxCount)];
    }
    
    [XTUserDefaultsUtils setObject:[NSArray arrayWithArray:historyArray] forKey:XTPhoneRechargeHistoryUserDefaultsKey];
}

#pragma mark - Private
- (void)loadHistory
{
    NSArray *defaultHistoryArray = [XTUserDefaultsUtils objectForKey:XTPhoneRechargeHistoryUserDefaultsKey];
    if (!defaultHistoryArray) {
        defaultHistoryArray = [NSArray array];
    }
    _historyArray = [NSMutableArray arrayWithArray:defaultHistoryArray];
}

- (void)clearHistory
{
    self.contentView.hidden = YES;
    
    [XTUserDefaultsUtils removeObjectForKey:XTPhoneRechargeHistoryUserDefaultsKey];
    [_historyArray removeAllObjects];
    [self.historyTableView reloadData];
    
    // 更新内容视图及子视图的frame
    self.historyTableView.xt_h = 0.0;
    self.clearButton.xt_y = self.historyTableView.xt_y + self.historyTableView.xt_h;
    self.bottomLine.xt_y = self.clearButton.xt_y + self.clearButton.xt_h;
    self.contentView.xt_h = self.historyTableView.xt_h + self.clearButton.xt_h + self.bottomLine.xt_h;
}

- (void)cancelSelect
{
    [self hide];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(phoneRechargeHistoryViewDidSelectCancel:)]) {
        [self.delegate phoneRechargeHistoryViewDidSelectCancel:self];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _historyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *XTPhoneRechargeHistoryCellIdentifier = @"XTPhoneRechargeHistoryCellIdentifier";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:XTPhoneRechargeHistoryCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:XTPhoneRechargeHistoryCellIdentifier];
        
        cell.textLabel.font = XTFont(16.0);
        cell.detailTextLabel.font = XTFont(10.0);
        cell.textLabel.textColor = XTBrandBlackColor;
        cell.detailTextLabel.textColor = XTBrandGrayColor;
    }
    
    NSDictionary *historyDict = _historyArray[indexPath.row];
    
    NSString *detail;
    if ([historyDict[@"Detail"] length] > 0) {
        detail = [NSString stringWithFormat:@"%@(%@)", historyDict[@"Name"], historyDict[@"Detail"]];
    } else {
        detail = [NSString stringWithFormat:@"%@", historyDict[@"Name"]];
    }
    
    cell.textLabel.text = historyDict[@"PhoneNumber"];
    cell.detailTextLabel.text = detail;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.separatorInset = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    cell.layoutMargins = UIEdgeInsetsZero;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self hide];
    
    NSDictionary *historyDict = _historyArray[indexPath.row];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(phoneRechargeHistoryView:didSelectPhoneNumber:name:)]) {
        [self.delegate phoneRechargeHistoryView:self didSelectPhoneNumber:historyDict[@"PhoneNumber"] name:historyDict[@"Name"]];
    }
}

@end
