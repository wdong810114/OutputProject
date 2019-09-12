//
//  XTLifePaymentAccountViewController.m
//  XTModulesSDK
//
//  Created by wdd on 2019/8/15.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTLifePaymentAccountViewController.h"

#import "ActionSheetCustomPicker.h"
#import "XTBaseWebViewController.h"
#import "XTLifePaymentApi.h"
#import "XTLifePaymentAccountTagCell.h"
#import "XTLifePaymentAccountCompanyCell.h"
#import "XTLifePaymentAccountNoCell.h"
#import "XTLifePaymentErrorAlertView.h"
#import "XTLifePaymentCityListViewController.h"
#import "XTLifePaymentPayBillViewController.h"

static NSInteger const XTTagsPickerTag = 1001;
static NSInteger const XTCompaniesPickerTag = 1002;

@interface XTLifePaymentAccountViewController () <UITableViewDataSource, UITableViewDelegate, ActionSheetCustomPickerDelegate, XTLifePaymentAccountNoCellDelegate, XTLifePaymentCityListViewControllerDelegate>

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UIView *tableFooterView;

@property (nonatomic, strong) XTLifePaymentErrorAlertView *errorAlertView;

@end

@implementation XTLifePaymentAccountViewController
{
    NSArray *_tagArray;
    NSArray *_companyArray;
    
    ActionSheetCustomPicker *_currentPicker;
    NSUInteger _pickerSelectedTagIndex;
    NSUInteger _pickerSelectedCompanyIndex;
    
    BOOL _isProtocolChecked;
    
    XTLifePaymentPayBillModel *_payBillModel;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isProtocolChecked = NO;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.accountModel) {
        self.accountModel = [[XTLifePaymentAccountModel alloc] init];
        self.accountModel.cityCode = @"24";
        self.accountModel.cityName = @"沈阳";
    }
    
    self.title = @"生活缴费";
    [self setLeftBarButtonItem:@selector(backButtonClicked) image:@"back_icon_n" highlightedImage:@"back_icon_h"];
    [self setRightBarButtonItem:@selector(locationButtonClicked) title:self.accountModel.cityName];
    
    [self.view addSubview:self.mainTableView];
    
    [self requestData];
}

- (void)setRightBarButtonItem:(SEL)action title:(NSString *)title
{
    UIImage *locationNormalImage = [UIImage imageNamed:XTModulesSDKImage(@"life_payment_location_n")];
    UIImage *locationHighlightedImage = [UIImage imageNamed:XTModulesSDKImage(@"life_payment_location_h")];
    CGFloat width = [XTAppUtils sizeOfString:title font:XTFont(14.0) constrainedToSize:CGSizeMake(100.0, 44.0)].width + 5.0 + locationNormalImage.size.width;
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, width, 44.0)];
    customView.backgroundColor = [UIColor clearColor];
    
    UIButton *actionButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(customView.bounds), CGRectGetHeight(customView.bounds))];
    actionButton.backgroundColor = [UIColor clearColor];
    actionButton.titleLabel.font = XTFont(14.0);
    [actionButton setTitleColor:XTBrandRedColor forState:UIControlStateNormal];
    [actionButton setTitleColor:[XTBrandRedColor colorWithAlphaComponent:0.8] forState:UIControlStateHighlighted];
    [actionButton setTitle:title forState:UIControlStateNormal];
    [actionButton setImage:locationNormalImage forState:UIControlStateNormal];
    [actionButton setImage:locationHighlightedImage forState:UIControlStateHighlighted];
    [actionButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [actionButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -actionButton.imageView.image.size.width - 2.5, 0.0, actionButton.imageView.image.size.width + 2.5)];
    [actionButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, actionButton.titleLabel.bounds.size.width + 2.5, 0.0, -actionButton.titleLabel.bounds.size.width - 2.5)];
    [customView addSubview:actionButton];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    self.navigationItem.rightBarButtonItems = @[rightButtonItem];
}

#pragma mark - Button
- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)locationButtonClicked
{
    XTLifePaymentCityListViewController *vc = [[XTLifePaymentCityListViewController alloc] init];
    vc.delegate = self;
    vc.lifePaymentType = self.lifePaymentType;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)nextButtonClicked
{
    [self.view endEditing:YES];
    
    if (![self checkValidity]) {
        return;
    }
    
    [self requestPayBillWithCompletion:^{
        if (self.isEdit) {
            [self requestEditAccount];
        } else {
            [self requestAddAccount];
        }
    }];
}

- (void)agreeButtonClicked:(UIButton *)button
{
    _isProtocolChecked = !_isProtocolChecked;
    button.selected = _isProtocolChecked;
}

- (void)protocolButtonClicked
{
    XTBaseWebViewController *vc = [[XTBaseWebViewController alloc] init];
    vc.urlString = @"http://docs.nsmetro.com/policies/payment_protocal";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private
- (void)requestData
{
    if (XTIsReachable) {
        [self showLoading];
        
        XTWeakSelf(weakSelf);
        
        dispatch_group_t group = dispatch_group_create();
        
        dispatch_group_enter(group);
        
        [[XTLifePaymentApi sharedAPI] postGetTagsWithCompletionHandler:^(NSArray<XTLifePaymentTagModel> *output, NSError *error) {
            dispatch_group_leave(group);
            
            if (!error) {
                if (output && output.count > 0) {
                    _tagArray = [NSArray arrayWithArray:output];
                    
                    if (!weakSelf.accountModel.tagCode || !weakSelf.accountModel.tagName) {
                        XTLifePaymentTagModel *model = _tagArray[0];
                        weakSelf.accountModel.tagCode = model.tagCode;
                        weakSelf.accountModel.tagName = model.tagName;
                    }
                }
            }
        }];
        
        dispatch_group_enter(group);
        
        [[XTLifePaymentApi sharedAPI] postGetCompaniesWithCityCode:self.accountModel.cityCode completionHandler:^(NSArray<XTLifePaymentCompanyModel> *output, NSError *error) {
            dispatch_group_leave(group);
            
            if (!error) {
                NSString *companyType = XTCompanyTypeFromLifePaymentType(self.lifePaymentType);
                
                NSMutableArray *companyArray = [[NSMutableArray alloc] init];
                if (output && output.count > 0) {
                    [output enumerateObjectsUsingBlock:^(XTLifePaymentCompanyModel *model, NSUInteger idx, BOOL *stop) {
                        if ([companyType isEqualToString:model.companyType]) {
                            [companyArray addObject:model];
                        }
                    }];
                }
                
                if (companyArray && companyArray.count > 0) {
                    _companyArray = [NSArray arrayWithArray:companyArray];
                    
                    if (!weakSelf.isEdit) {
                        XTLifePaymentCompanyModel *model = _companyArray[0];
                        weakSelf.accountModel.companyCode = model.companyCode;
                        weakSelf.accountModel.companyName = model.companyName;
                    } else {
                        BOOL isFound = NO;
                        for (XTLifePaymentCompanyModel *model in _companyArray) {
                            if ([model.companyCode isEqualToString:weakSelf.accountModel.companyCode]) {
                                isFound = YES;
                                break;
                            }
                        }
                        
                        if (!isFound) {
                            XTLifePaymentCompanyModel *model = _companyArray[0];
                            weakSelf.accountModel.companyCode = model.companyCode;
                            weakSelf.accountModel.companyName = model.companyName;
                        }
                    }
                } else {
                    weakSelf.accountModel.companyCode = nil;
                    weakSelf.accountModel.companyName = nil;
                    
                    [weakSelf showToastWithText:@"当前城市没有缴费公司"];
                }
            }
        }];
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^(){
            [weakSelf hideLoading];
            
            [weakSelf.mainTableView reloadRowsAtIndexPaths:@[XTIndexPath(0, 0), XTIndexPath(1, 0)] withRowAnimation:UITableViewRowAnimationNone];
        });
    } else {
        [self showToastWithText:XTNetworkUnavailable];
    }
}

- (BOOL)checkValidity
{
    if (XTStringIsEmpty(self.accountModel.accountNo)) {
        [self showToastWithText:@"请填写用户编号"];
        return NO;
    }
    
    if (XTStringIsEmpty(self.accountModel.tagCode)) {
        [self showToastWithText:@"请选择标签"];
        return NO;
    }
    
    if (XTStringIsEmpty(self.accountModel.companyCode)) {
        [self showToastWithText:@"请选择缴费单位"];
        return NO;
    }
    
    if (!self.isEdit) {
        if (!_isProtocolChecked) {
            [self showToastWithText:@"请同意缴费协议"];
            return NO;
        }
    }
    
    return YES;
}

- (void)requestEditAccount
{
    if (XTIsReachable) {
        [self showLoading];
        
        NSString *uuid = self.accountModel.uuid;
        NSString *tagCode = self.accountModel.tagCode;
        NSString *accountAddress = _payBillModel.accountAddress;
        NSString *accountNo = _payBillModel.accountNo;
        NSString *accountType = XTAccountTypeFromLifePaymentType(self.lifePaymentType);
        NSString *cityCode = self.accountModel.cityCode;
        NSString *companyCode = self.accountModel.companyCode;
        NSString *phone = [XTModulesManager sharedManager].phone;
        
        XTWeakSelf(weakSelf);
        [[XTLifePaymentApi sharedAPI] postEditAccountWithUUID:uuid tagCode:tagCode accountAddress:accountAddress accountNo:accountNo accountType:accountType cityCode:cityCode companyCode:companyCode phone:phone completionHandler:^(XTModuleObject *output, NSError *error) {
            [weakSelf hideLoading];
            
            if (!error) {
                [weakSelf toPayBill];
            }
        }];
    } else {
        [self showToastWithText:XTNetworkUnavailable];
    }
}

- (void)requestAddAccount
{
    if (XTIsReachable) {
        [self showLoading];
        
        NSString *accountNo = _payBillModel.accountNo;
        NSString *tagCode = self.accountModel.tagCode;
        NSString *accountType = XTAccountTypeFromLifePaymentType(self.lifePaymentType);
        NSString *cityCode = self.accountModel.cityCode;
        NSString *companyCode = self.accountModel.companyCode;
        NSString *phone = [XTModulesManager sharedManager].phone;
        NSString *accountAddress = _payBillModel.accountAddress;
        
        XTWeakSelf(weakSelf);
        [[XTLifePaymentApi sharedAPI] postAddAccountWithAccountNo:accountNo tagCode:tagCode accountType:accountType cityCode:cityCode companyCode:companyCode phone:phone accountAddress:accountAddress completionHandler:^(XTModuleObject *output, NSError *error) {
            [weakSelf hideLoading];
            
            if (!error) {
                [weakSelf toPayBill];
            }
        }];
    } else {
        [self showToastWithText:XTNetworkUnavailable];
    }
}

- (void)requestPayBillWithCompletion:(void (^)(void))completion
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
                _payBillModel = output;
                
                if (_payBillModel.code.integerValue == 0) {
                    completion();
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
    if (!self.errorAlertView) {
        XTLifePaymentErrorAlertView *errorAlertView = [[XTLifePaymentErrorAlertView alloc] initWithFrame:XTMainScreenBounds];
        errorAlertView.title = @"账号信息查询失败";
        errorAlertView.iconImage = [UIImage imageNamed:XTModulesSDKImage(@"life_payment_receipt")];
        self.errorAlertView = errorAlertView;
    }
    self.errorAlertView.message = message;
    
    [self.errorAlertView show];
}

- (void)toPayBill
{
    XTLifePaymentPayBillViewController *vc = [[XTLifePaymentPayBillViewController alloc] init];
    vc.lifePaymentType = self.lifePaymentType;
    vc.accountModel = self.accountModel;
    vc.payBillModel = _payBillModel;
    [self.navigationController pushViewController:vc animated:YES];
    
    NSMutableArray *vcArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [vcArray removeObject:self];
    [self.navigationController setViewControllers:vcArray];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            XTLifePaymentAccountTagCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XTLifePaymentAccountTagCellIdentifier" forIndexPath:indexPath];
            
            cell.tagLabel.text = self.accountModel.tagName;
            
            return cell;
        }
            break;
        case 1:
        {
            XTLifePaymentAccountCompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XTLifePaymentAccountCompanyCellIdentifier" forIndexPath:indexPath];
            
            cell.companyLabel.text = self.accountModel.companyName;
            
            return cell;
        }
            break;
        case 2:
        {
            XTLifePaymentAccountNoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XTLifePaymentAccountNoCellIdentifier" forIndexPath:indexPath];
            cell.delegate = self;
            
            switch (self.lifePaymentType) {
                case XTLifePaymentTypeWater:
                case XTLifePaymentTypeGas:
                    cell.noTextField.placeholder = @"查看纸质账单";
                    break;
                case XTLifePaymentTypeElectric:
                    cell.noTextField.placeholder = @"查看纸质账单或拨95598";
                    break;
                    
                default:
                    cell.noTextField.placeholder = @"";
                    break;
            }
            
            cell.noTextField.text = self.accountModel.accountNo;
            
            return cell;
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            [self.view endEditing:YES];
            
            if (_tagArray.count == 0) {
                [self showToastWithText:@"没有可选择的标签"];
                return;
            }
            
            __block NSUInteger index = 0;
            [_tagArray enumerateObjectsUsingBlock:^(XTLifePaymentTagModel *model, NSUInteger idx, BOOL *stop) {
                if ([self.accountModel.tagCode isEqualToString:model.tagCode]) {
                    index = idx;
                    *stop = YES;
                }
            }];

            _pickerSelectedTagIndex = index;
            ActionSheetCustomPicker *picker = [[ActionSheetCustomPicker alloc] initWithTitle:@"选择标签" delegate:self showCancelButton:YES origin:self.view initialSelections:@[@(_pickerSelectedTagIndex)]];
            picker.titleTextAttributes = @{NSFontAttributeName : XTFont(17.0), NSForegroundColorAttributeName : XTBrandBlackColor};
            picker.tag = XTTagsPickerTag;
            _currentPicker = picker;
            [picker showActionSheetPicker];
        }
            break;
        case 1:
        {
            [self.view endEditing:YES];
            
            if (_companyArray.count == 0) {
                [self showToastWithText:@"没有可选择的缴费单位"];
                return;
            }
            
            __block NSUInteger index = 0;
            [_companyArray enumerateObjectsUsingBlock:^(XTLifePaymentCompanyModel *model, NSUInteger idx, BOOL *stop) {
                if ([self.accountModel.companyCode isEqualToString:model.companyCode]) {
                    index = idx;
                    *stop = YES;
                }
            }];
            
            _pickerSelectedCompanyIndex = index;
            ActionSheetCustomPicker *picker = [[ActionSheetCustomPicker alloc] initWithTitle:@"选择缴费单位" delegate:self showCancelButton:YES origin:self.view initialSelections:@[@(_pickerSelectedCompanyIndex)]];
            picker.titleTextAttributes = @{NSFontAttributeName : XTFont(17.0), NSForegroundColorAttributeName : XTBrandBlackColor};
            picker.tag = XTCompaniesPickerTag;
            _currentPicker = picker;
            [picker showActionSheetPicker];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - ActionSheetCustomPickerDelegate
- (void)actionSheetPicker:(AbstractActionSheetPicker *)actionSheetPicker configurePickerView:(UIPickerView *)pickerView
{
    actionSheetPicker.pickerBackgroundColor = [UIColor whiteColor];
}

- (void)actionSheetPickerDidSucceed:(AbstractActionSheetPicker *)actionSheetPicker origin:(id)origin
{
    if (XTTagsPickerTag == _currentPicker.tag) {
        XTLifePaymentTagModel *model = _tagArray[_pickerSelectedTagIndex];
        self.accountModel.tagCode = model.tagCode;
        self.accountModel.tagName = model.tagName;
        
        [self.mainTableView reloadRowsAtIndexPaths:@[XTIndexPath(0, 0)] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        XTLifePaymentCompanyModel *model = _companyArray[_pickerSelectedCompanyIndex];
        self.accountModel.companyCode = model.companyCode;
        self.accountModel.companyName = model.companyName;
        
        [self.mainTableView reloadRowsAtIndexPaths:@[XTIndexPath(1, 0)] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    _currentPicker = nil;
}

- (void)actionSheetPickerDidCancel:(AbstractActionSheetPicker *)actionSheetPicker origin:(id)origin
{
    _currentPicker = nil;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (XTTagsPickerTag == _currentPicker.tag) {
        return _tagArray.count;
    } else {
        return _companyArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (XTTagsPickerTag == _currentPicker.tag) {
        XTLifePaymentTagModel *model = _tagArray[row];
        return model.tagName;
    } else {
        XTLifePaymentCompanyModel *model = _companyArray[row];
        return model.companyName;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (XTTagsPickerTag == _currentPicker.tag) {
        _pickerSelectedTagIndex = row;
    } else {
        _pickerSelectedCompanyIndex = row;
    }
}

#pragma mark - XTLifePaymentAccountNoCellDelegate
- (void)lifePaymentAccountNoCell:(XTLifePaymentAccountNoCell *)lifePaymentAccount didChangeAccountNo:(NSString *)accountNo
{
    self.accountModel.accountNo = accountNo;
}

#pragma mark - XTLifePaymentCityListViewControllerDelegate
- (void)lifePaymentCityListViewController:(XTLifePaymentCityListViewController *)lifePaymentCityListViewController didSelectCityModel:(XTLifePaymentCityModel *)cityModel
{
    [self.navigationController popToViewController:self animated:YES];
    
    if (XTIsReachable) {
        self.accountModel.cityCode = cityModel.cityCode;
        self.accountModel.cityName = cityModel.cityName;
        
        [self setRightBarButtonItem:@selector(locationButtonClicked) title:self.accountModel.cityName];
        
        [self requestData];
    } else {
        [self showToastWithText:XTNetworkUnavailable];
    }
}

#pragma mark - Getter
- (UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, XTMainScreenWidth, XTNonTopLevelViewHeight) style:UITableViewStylePlain];
        _mainTableView.backgroundColor = [UIColor clearColor];
        _mainTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.alwaysBounceVertical = YES;
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _mainTableView.separatorColor = XTSeparatorColor;
        _mainTableView.tableHeaderView = self.tableHeaderView;
        _mainTableView.tableFooterView = self.tableFooterView;
        if (@available(iOS 11.0, *)) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_mainTableView registerNib:XTModulesSDKNib(@"XTLifePaymentAccountTagCell") forCellReuseIdentifier:@"XTLifePaymentAccountTagCellIdentifier"];
        [_mainTableView registerNib:XTModulesSDKNib(@"XTLifePaymentAccountCompanyCell") forCellReuseIdentifier:@"XTLifePaymentAccountCompanyCellIdentifier"];
        [_mainTableView registerNib:XTModulesSDKNib(@"XTLifePaymentAccountNoCell") forCellReuseIdentifier:@"XTLifePaymentAccountNoCellIdentifier"];
    }
    
    return _mainTableView;
}

- (UIView *)tableHeaderView
{
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.mainTableView.bounds), 120.0)];
        _tableHeaderView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *typeImageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(_tableHeaderView.bounds) - 36.0) / 2, 38.0, 36.0, 36.0)];
        typeImageView.backgroundColor = [UIColor clearColor];
        
        UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(typeImageView.frame) + 10.0, CGRectGetWidth(_tableHeaderView.bounds), 25.0)];
        typeLabel.backgroundColor = [UIColor clearColor];
        typeLabel.font = XTFont(18.0);
        typeLabel.textAlignment = NSTextAlignmentCenter;
        typeLabel.textColor = XTBrandBlackColor;
        
        switch (self.lifePaymentType) {
            case XTLifePaymentTypeWater:
            {
                typeImageView.image = [UIImage imageNamed:XTModulesSDKImage(@"life_payment_water")];
                typeLabel.text = @"水费";
            }
                break;
            case XTLifePaymentTypeElectric:
            {
                typeImageView.image = [UIImage imageNamed:XTModulesSDKImage(@"life_payment_electric")];
                typeLabel.text = @"电费";
            }
                break;
            case XTLifePaymentTypeGas:
            {
                typeImageView.image = [UIImage imageNamed:XTModulesSDKImage(@"life_payment_gas")];
                typeLabel.text = @"燃气费";
            }
                break;
                
            default:
                break;
        }
        
        [_tableHeaderView addSubview:typeImageView];
        [_tableHeaderView addSubview:typeLabel];
    }
    
    return _tableHeaderView;
}

- (UIView *)tableFooterView
{
    if (!_tableFooterView) {
        _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.mainTableView.bounds), 147.0)];
        _tableFooterView.backgroundColor = [UIColor clearColor];
        
        UIButton *nextButton = [XTAppUtils redButtonWithFrame:CGRectMake(20.0, 65.0, CGRectGetWidth(_tableFooterView.bounds) - 20.0 * 2, 45.0)];
        nextButton.titleLabel.font = XTFont(18.0);
        [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(nextButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *agreeString = @"已阅读并同意《缴费服务协议》";
        NSInteger tipLength = 6;
        CGSize constrainedToSize = CGSizeMake(300.0, 37.0);
        CGFloat width = 22.0 + [XTAppUtils sizeOfString:agreeString
                                                   font:XTFont(12.0)
                                      constrainedToSize:constrainedToSize].width;
        CGFloat tipWidth = [XTAppUtils sizeOfString:[agreeString substringToIndex:tipLength]
                                               font:XTFont(12.0)
                                  constrainedToSize:constrainedToSize].width;
        CGFloat protocolWidth = [XTAppUtils sizeOfString:[agreeString substringFromIndex:tipLength]
                                                    font:XTFont(12.0)
                                       constrainedToSize:constrainedToSize].width;
        
        UIView *protocolView = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(_tableFooterView.bounds) - width) / 2, CGRectGetMaxY(nextButton.frame), width, constrainedToSize.height)];
        protocolView.backgroundColor = [UIColor clearColor];
        protocolView.hidden = self.isEdit;
        
        UIButton *agreeButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 22.0, CGRectGetHeight(protocolView.bounds))];
        agreeButton.backgroundColor = [UIColor clearColor];
        agreeButton.adjustsImageWhenHighlighted = NO;
        [agreeButton setImage:[UIImage imageNamed:XTModulesSDKImage(@"protocol_disagree")] forState:UIControlStateNormal];
        [agreeButton setImage:[UIImage imageNamed:XTModulesSDKImage(@"protocol_agree")] forState:UIControlStateSelected];
        [agreeButton addTarget:self action:@selector(agreeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(agreeButton.frame), 0.0, tipWidth, CGRectGetHeight(protocolView.bounds))];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.font = XTFont(12.0);
        tipLabel.textColor = XTBrandGrayColor;
        tipLabel.text = [agreeString substringToIndex:tipLength];
        
        UIButton *protocolButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tipLabel.frame), 0.0, protocolWidth, CGRectGetHeight(protocolView.bounds))];
        protocolButton.backgroundColor = [UIColor clearColor];
        protocolButton.titleLabel.font = XTFont(12.0);
        [protocolButton setTitleColor:XTBrandRedColor forState:UIControlStateNormal];
        [protocolButton setTitleColor:[XTBrandRedColor colorWithAlphaComponent:0.8] forState:UIControlStateHighlighted];
        [protocolButton setTitle:@"《缴费服务协议》" forState:UIControlStateNormal];
        [protocolButton addTarget:self action:@selector(protocolButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [protocolView addSubview:agreeButton];
        [protocolView addSubview:tipLabel];
        [protocolView addSubview:protocolButton];
        
        [_tableFooterView addSubview:nextButton];
        [_tableFooterView addSubview:protocolView];
    }
    
    return _tableFooterView;
}

@end
