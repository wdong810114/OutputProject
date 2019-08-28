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
#import "XTLifePaymentErrorAlertView.h"
#import "XTOrder.h"

@interface XTLifePaymentPayBillViewController () <UITableViewDataSource, UITableViewDelegate, XTLifePaymentPayBillMoneyCellDelegate, XTLifePaymentErrorAlertViewDelegate>

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, strong) XTLifePaymentErrorAlertView *errorAlertView;

@end

@implementation XTLifePaymentPayBillViewController
{
    NSString *_money;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"生活缴费";
    [self setLeftBarButtonItem:@selector(backButtonClicked) image:@"back_icon_n" highlightedImage:@"back_icon_h"];
    
    [self.view addSubview:self.mainTableView];
    [self.view addSubview:self.nextButton];
    
    if (!self.payBillModel) {
        [self requestPayBill];
    }
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
        
        NSString *accountNo = self.payBillModel.accountNo;
        NSString *phone = [XTModulesManager sharedManager].phone;
        NSString *companyCode = self.accountModel.companyCode;
        NSString *cityCode = self.accountModel.cityCode;
        NSString *accountType = XTAccountTypeFromLifePaymentType(self.lifePaymentType);
        NSInteger orderType = -1;
        switch (self.lifePaymentType) {
            case XTLifePaymentTypeWater:
                orderType = 2;
                break;
            case XTLifePaymentTypeElectric:
                orderType = 3;
                break;
            case XTLifePaymentTypeGas:
                orderType = 4;
                break;
                
            default:
                break;
        }
        NSString *accountAddress = self.payBillModel.accountAddress;
        NSString *amount = [_money copy];
        
        XTWeakSelf(weakSelf);
        [[XTLifePaymentApi sharedAPI] postGetLifePaymentOrderWithAccountNo:accountNo phone:phone companyCode:companyCode cityCode:cityCode accountType:accountType accountAddress:accountAddress amount:amount completionHandler:^(XTLifePaymentOrderModel *output, NSError *error) {
            [weakSelf hideLoading];
            
            if (!error) {
                XTOrder *order = [[XTOrder alloc] init];
                order.orderType = orderType;
                order.orderId = output.orderId;
                order.orderAmount = amount;
                
                id object = [XTModulesManager sharedManager].sourceVC;
                NSDictionary *userInfo = [order toDictionary];
                
                [XTNotificationCenter postNotificationName:XTLifeServicePlaceOrderDidSuccessNotification object:object userInfo:userInfo];
            }
        }];
    } else {
        [self showAlert:XTNetworkUnavailable];
    }
}

#pragma mark - Private
- (void)requestPayBill
{
    if (XTIsReachable) {
        [self showLoading];
        
        NSString *accountNo = self.accountModel.accountNo;
        NSString *companyCode = self.accountModel.companyCode;
        NSString *cityCode = self.accountModel.cityCode;
        NSString *accountType = XTAccountTypeFromLifePaymentType(self.lifePaymentType);
        
        XTWeakSelf(weakSelf);
        [[XTLifePaymentApi sharedAPI] postQueryAccountInfoWithAccountNo:accountNo companyCode:companyCode cityCode:cityCode accountType:accountType completionHandler:^(XTLifePaymentPayBillModel *output, NSError *error) {
            [weakSelf hideLoading];
            
            if (!error) {
                weakSelf.payBillModel = output;
                
                if (weakSelf.payBillModel.code.integerValue == 0) {
                    [weakSelf.mainTableView reloadData];
                } else {
                    [weakSelf showErrorAlertWithMessage:weakSelf.payBillModel.message];
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
    if (!self.errorAlertView) {
        XTLifePaymentErrorAlertView *errorAlertView = [[XTLifePaymentErrorAlertView alloc] initWithFrame:XTMainScreenBounds];
        errorAlertView.delegate = self;
        errorAlertView.title = @"账号信息查询失败";
        errorAlertView.iconImage = [UIImage imageNamed:XTModulesSDKImage(@"life_payment_receipt")];
        self.errorAlertView = errorAlertView;
    }
    self.errorAlertView.message = message;
    
    [self.errorAlertView show];
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
    
    if (XTStringIsEmpty(self.payBillModel.accountNo)) {
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
            
            cell.noLabel.text = self.payBillModel.accountNo;
            
            return cell;
        } else {
            XTLifePaymentPayBillContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XTLifePaymentPayBillContentCellIdentifier" forIndexPath:indexPath];
            
            cell.accountAddressLabel.text = self.payBillModel.accountAddress;
            cell.companyNameLabel.text = self.payBillModel.companyName;
            cell.arrearageLabel.text = [NSString stringWithFormat:@"¥ %.2f", [self.payBillModel.arrearage floatValue]];
            cell.balanceLabel.text = [NSString stringWithFormat:@"¥ %.2f", [self.payBillModel.balance floatValue]];
            
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

#pragma mark - XTLifePaymentErrorAlertViewDelegate
- (void)lifePaymentErrorAlertViewDidClickKnow:(XTLifePaymentErrorAlertView *)lifePaymentErrorAlertView
{
    [self.navigationController popViewControllerAnimated:YES];
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
        [_mainTableView registerNib:XTModulesSDKNib(@"XTLifePaymentPayBillTitleCell") forCellReuseIdentifier:@"XTLifePaymentPayBillTitleCellIdentifier"];
        [_mainTableView registerNib:XTModulesSDKNib(@"XTLifePaymentPayBillContentCell") forCellReuseIdentifier:@"XTLifePaymentPayBillContentCellIdentifier"];
        [_mainTableView registerNib:XTModulesSDKNib(@"XTLifePaymentPayBillMoneyCell") forCellReuseIdentifier:@"XTLifePaymentPayBillMoneyCellIdentifier"];
    }
    
    return _mainTableView;
}

- (UIButton *)nextButton
{
    if (!_nextButton) {
        _nextButton = [XTAppUtils redButtonWithFrame:CGRectMake(0.0, XTNonTopLevelViewHeight - 45.0, XTMainScreenWidth, 45.0)];
        _nextButton.titleLabel.font = XTFont(18.0);
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(nextButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        _nextButton.enabled = NO;
    }
    
    return _nextButton;
}

@end
