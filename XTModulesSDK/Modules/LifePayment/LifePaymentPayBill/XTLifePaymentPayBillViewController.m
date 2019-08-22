//
//  XTLifePaymentPayBillViewController.m
//  XTModulesSDK
//
//  Created by wdd on 2019/8/15.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTLifePaymentPayBillViewController.h"

#import "XTLifePaymentApi.h"
#import "XTLifePaymentPayBillTitleCell.h"
#import "XTLifePaymentPayBillContentCell.h"
#import "XTLifePaymentPayBillMoneyCell.h"

@interface XTLifePaymentPayBillViewController () <UITableViewDataSource, UITableViewDelegate, XTLifePaymentPayBillMoneyCellDelegate>

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, strong) UIView *errorAlertView;

@end

@implementation XTLifePaymentPayBillViewController
{
    XTLifePaymentPayBillModel *_payBillModel;
    
    NSString *_money;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"生活缴费";
    [self setLeftBarButtonItem:@selector(backButtonClicked) image:@"back_icon_n" highlightedImage:@"back_icon_h"];
    
    [self.view addSubview:self.mainTableView];
    [self.view addSubview:self.nextButton];
    
    [self requestPayBill];
}

#pragma mark - Button
- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextButtonClicked
{
    [self.view endEditing:YES];
    
    if (![self checkValidity]) {
        return;
    }
    
    if (XTIsReachable) {
        [self showLoading];
        
        NSString *accountNo = _payBillModel.accountNo;
        NSString *phone = [XTModulesManager sharedManager].phone;
        NSString *companyCode = self.accountModel.companyCode;
        NSString *cityCode = self.accountModel.cityCode;
        NSString *accountType = nil;
        NSInteger orderType = -1;
        switch (self.lifePaymentType) {
            case XTLifePaymentTypeWater:
            {
                accountType = @"1";
                orderType = 2;
            }
                break;
            case XTLifePaymentTypeElectric:
            {
                accountType = @"2";
                orderType = 3;
            }
                break;
            case XTLifePaymentTypeGas:
            {
                accountType = @"3";
                orderType = 4;
            }
                break;
                
            default:
                break;
        }
        NSString *accountAddress = _payBillModel.accountAddress;
        NSString *amount = [_money copy];
        
        XTWeakSelf(weakSelf);
        [[XTLifePaymentApi sharedAPI] postGetLifePaymentOrderWithAccountNo:accountNo phone:phone companyCode:companyCode cityCode:cityCode accountType:accountType accountAddress:accountAddress amount:amount completionHandler:^(XTLifePaymentOrderModel *output, NSError *error) {
            [weakSelf hideLoading];
            
            if (!error) {
                XTOrder *order = [[XTOrder alloc] init];
                order.orderType = orderType;
                order.orderId = output.orderId;
                order.amount = amount;
                [XTNotificationCenter postNotificationName:XTLifeServicePlaceOrderDidSuccessNotification object:order];
            }
        }];
    } else {
        [self showAlert:XTNetworkUnavailable];
    }
}

- (void)knowButtonClicked
{
    [UIView animateWithDuration:0.25 animations:^{
        self.errorAlertView.hidden = YES;
    } completion:^(BOOL finished) {
        [self.errorAlertView removeFromSuperview];
        self.errorAlertView = nil;
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - Private
- (void)requestPayBill
{
    if (XTIsReachable) {
        [self showLoading];
        
        NSString *accountNo = self.accountModel.accountNo;
        NSString *companyCode = self.accountModel.companyCode;
        NSString *cityCode = self.accountModel.cityCode;
        NSString *accountType = nil;
        switch (self.lifePaymentType) {
            case XTLifePaymentTypeWater:
                accountType = @"1";
                break;
            case XTLifePaymentTypeElectric:
                accountType = @"2";
                break;
            case XTLifePaymentTypeGas:
                accountType = @"3";
                break;
                
            default:
                break;
        }
        
        XTWeakSelf(weakSelf);
        [[XTLifePaymentApi sharedAPI] postQueryAccountInfoWithAccountNo:accountNo companyCode:companyCode cityCode:cityCode accountType:accountType completionHandler:^(XTLifePaymentPayBillModel *output, NSError *error) {
            [weakSelf hideLoading];
            
            if (!error) {
                _payBillModel = output;
                
                if (_payBillModel.code.integerValue == 0) {
                    [weakSelf.mainTableView reloadData];
                } else {
                    [weakSelf showErrorAlertWithMessage:_payBillModel.message];
                }
            } else {
                if (error.domain == XTBusinessDataErrorDomain && error.code != XTUserTokenInvalidErrorCode) {
                    [weakSelf showErrorAlertWithMessage:error.userInfo[NSLocalizedDescriptionKey]];
                }
            }
        }];
    } else {
        [self showAlert:XTNetworkUnavailable];
    }
}

- (void)showErrorAlertWithMessage:(NSString *)message
{
    UIView *errorAlertView = [[UIView alloc] initWithFrame:XTMainScreenBounds];
    errorAlertView.backgroundColor = [UIColor clearColor];
    errorAlertView.hidden = YES;
    self.errorAlertView = errorAlertView;
    
    UIView *translucentView = [[UIView alloc] initWithFrame:errorAlertView.bounds];
    translucentView.backgroundColor = [UIColor blackColor];
    translucentView.alpha = 0.5;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(errorAlertView.bounds) - 280.0) / 2, (CGRectGetHeight(errorAlertView.bounds) - 210.0) / 2, 280.0, 210.0)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = 5.0;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 0.0, CGRectGetWidth(contentView.bounds) - 20.0 * 2, 40.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = XTFont(14.0);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = XTColorFromHex(0x333333);
    titleLabel.text = @"账号信息查询失败";
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(titleLabel.frame), CGRectGetWidth(contentView.bounds), 1.0)];
    separator.backgroundColor = XTColorFromHex(0xEDEDED);
    
    UIImageView *receiptImageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(contentView.bounds) - 50.0) / 2, CGRectGetMaxY(separator.frame) + 24.0, 50.0, 50.0)];
    receiptImageView.backgroundColor = [UIColor clearColor];
    receiptImageView.image = [UIImage imageNamed:XTModulesSDKImage(@"life_payment_receipt")];
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, CGRectGetMaxY(receiptImageView.frame), CGRectGetWidth(contentView.bounds) - 20.0 * 2, 55.0)];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.numberOfLines = 2;
    messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    messageLabel.font = XTFont(12.0);
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.textColor = XTColorFromHex(0xCCCCCC);
    messageLabel.text = message;
    
    UIButton *knowButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, CGRectGetHeight(contentView.bounds) - 40.0, CGRectGetWidth(contentView.bounds), 40.0)];
    knowButton.backgroundColor = [UIColor clearColor];
    [knowButton setBackgroundImage:[XTAppUtils imageWithColor:XTBrandBlueColor] forState:UIControlStateNormal];
    [knowButton setBackgroundImage:[XTAppUtils imageWithColor:[XTBrandBlueColor colorWithAlphaComponent:0.8]] forState:UIControlStateHighlighted];
    knowButton.titleLabel.font = XTFont(14.0);
    [knowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [knowButton setTitle:@"我知道了" forState:UIControlStateNormal];
    [knowButton addTarget:self action:@selector(knowButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [contentView addSubview:titleLabel];
    [contentView addSubview:separator];
    [contentView addSubview:receiptImageView];
    [contentView addSubview:messageLabel];
    [contentView addSubview:knowButton];

    [errorAlertView addSubview:translucentView];
    [errorAlertView addSubview:contentView];
    
    [XTMainWindow addSubview:errorAlertView];
    
    [UIView animateWithDuration:0.25 animations:^{
        errorAlertView.hidden = NO;
    }];
}

- (BOOL)checkValidity
{
    if (_money.floatValue < 30.0) {
        [self showToastWithText:@"最低缴费金额30元"];
        return NO;
    }

    if (!(XTLifePaymentTypeWater == self.lifePaymentType ||
          XTLifePaymentTypeElectric == self.lifePaymentType ||
          XTLifePaymentTypeGas == self.lifePaymentType)) {
        [self showToastWithText:@"缴费账户类型错误"];
        return NO;
    }
    
    if (XTStringIsEmpty(_payBillModel.accountNo)) {
        [self showToastWithText:@"缴费账户信息错误"];
        return NO;
    }
    
    return YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            XTLifePaymentPayBillTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XTLifePaymentPayBillTitleCellIdentifier" forIndexPath:indexPath];
            
            switch (self.lifePaymentType) {
                case XTLifePaymentTypeWater:
                {
                    cell.typeImageView.image = [UIImage imageNamed:XTModulesSDKImage(@"life_payment_water")];
                    cell.typeLabel.text = @"水费";
                }
                    break;
                case XTLifePaymentTypeElectric:
                {
                    cell.typeImageView.image = [UIImage imageNamed:XTModulesSDKImage(@"life_payment_electric")];
                    cell.typeLabel.text = @"电费";
                }
                    break;
                case XTLifePaymentTypeGas:
                {
                    cell.typeImageView.image = [UIImage imageNamed:XTModulesSDKImage(@"life_payment_gas")];
                    cell.typeLabel.text = @"燃气费";
                }
                    break;
                    
                default:
                    break;
            }
            
            cell.noLabel.text = _payBillModel.accountNo;
            
            return cell;
        } else {
            XTLifePaymentPayBillContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XTLifePaymentPayBillContentCellIdentifier" forIndexPath:indexPath];
            
            cell.accountAddressLabel.text = _payBillModel.accountAddress;
            cell.companyNameLabel.text = _payBillModel.companyName;
            cell.arrearageLabel.text = [NSString stringWithFormat:@"¥ %.2f", [_payBillModel.arrearage floatValue]];
            cell.balanceLabel.text = [NSString stringWithFormat:@"¥ %.2f", [_payBillModel.balance floatValue]];
            
            return cell;
        }
    } else {
        XTLifePaymentPayBillMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XTLifePaymentPayBillMoneyCellIdentifier" forIndexPath:indexPath];
        cell.delegate = self;
        cell.moneyTextField.text = [_money copy];
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 55.0;
        } else {
            return 160.0;
        }
    } else {
        return 50.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"XTLifePaymentPayBillVCHFIDHeaderSection"];
    if (!view) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"XTLifePaymentPayBillVCHFIDHeaderSection"];
        view.contentView.backgroundColor = [UIColor clearColor];
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"XTLifePaymentPayBillVCHFIDFooterSection"];
    if (!view) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"XTLifePaymentPayBillVCHFIDFooterSection"];
        view.contentView.backgroundColor = [UIColor clearColor];
    }
    
    return view;
}

#pragma mark - XTLifePaymentPayBillMoneyCellDelegate
- (void)lifePaymentPayBillMoneyCell:(XTLifePaymentPayBillMoneyCell *)lifePaymentPayBillMoneyCell didChangeMoney:(NSString *)money
{
    _money = [money copy];
    
    self.nextButton.enabled = money.floatValue > 0.0;
}

#pragma mark - Getter
- (UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, XTMainScreenWidth, XTNonTopLevelViewHeight - 45.0) style:UITableViewStyleGrouped];
        _mainTableView.backgroundColor = [UIColor clearColor];
        _mainTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.alwaysBounceVertical = YES;
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _mainTableView.separatorColor = XTSeparatorColor;
        _mainTableView.tableFooterView = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_mainTableView registerNib:[UINib nibWithNibName:XTModulesSDKResource(@"XTLifePaymentPayBillTitleCell") bundle:nil] forCellReuseIdentifier:@"XTLifePaymentPayBillTitleCellIdentifier"];
        [_mainTableView registerNib:[UINib nibWithNibName:XTModulesSDKResource(@"XTLifePaymentPayBillContentCell") bundle:nil] forCellReuseIdentifier:@"XTLifePaymentPayBillContentCellIdentifier"];
        [_mainTableView registerNib:[UINib nibWithNibName:XTModulesSDKResource(@"XTLifePaymentPayBillMoneyCell") bundle:nil] forCellReuseIdentifier:@"XTLifePaymentPayBillMoneyCellIdentifier"];
    }
    
    return _mainTableView;
}

- (UIButton *)nextButton
{
    if (!_nextButton) {
        _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, XTNonTopLevelViewHeight - 45.0, XTMainScreenWidth, 45.0)];
        _nextButton.backgroundColor = [UIColor clearColor];
        [_nextButton setBackgroundImage:[XTAppUtils imageWithColor:XTBrandBlueColor] forState:UIControlStateNormal];
        [_nextButton setBackgroundImage:[XTAppUtils imageWithColor:[XTBrandBlueColor colorWithAlphaComponent:0.8]] forState:UIControlStateHighlighted];
        [_nextButton setBackgroundImage:[XTAppUtils imageWithColor:[XTBrandBlueColor colorWithAlphaComponent:0.4]] forState:UIControlStateDisabled];
        _nextButton.titleLabel.font = XTFont(18.0);
        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(nextButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        _nextButton.enabled = NO;
    }
    
    return _nextButton;
}

@end
