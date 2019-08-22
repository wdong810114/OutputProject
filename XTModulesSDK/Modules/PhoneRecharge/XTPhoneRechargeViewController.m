//
//  XTPhoneRechargeViewController.m
//  XTModulesSDK
//
//  Created by wdd on 2019/7/22.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTPhoneRechargeViewController.h"

#import <AddressBookUI/AddressBookUI.h>
#import <ContactsUI/ContactsUI.h>
#import "XTPhoneRechargeApi.h"
#import "XTPhonePriceButton.h"
#import "XTPhoneRechargeHistoryView.h"

@interface XTPhoneRechargeViewController () <UITextFieldDelegate, ABPeoplePickerNavigationControllerDelegate, CNContactPickerDelegate, XTPhoneRechargeHistoryViewDelegate>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UITextField *phoneNumberTextField;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *contactButton;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) XTPhoneRechargeHistoryView *historyView;

@end

@implementation XTPhoneRechargeViewController
{
    NSMutableArray *_priceButtonArray;
    
    NSString *_name;
    NSString *_detail;
    
    NSArray *_phoneGoodsArray;
}

- (void)dealloc
{
    [XTNotificationCenter removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [XTNotificationCenter addObserver:self
                                 selector:@selector(phoneRechargeSuccess)
                                     name:XTLifeServicePayDidSuccessNotification
                                   object:nil];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"话费充值";
    [self setLeftBarButtonItem:@selector(backButtonClicked) image:@"back_icon_n" highlightedImage:@"back_icon_h"];
    
    [self initView];
}

- (void)backButtonClicked
{
    if (XTModuleShowModePush == [XTModulesManager sharedManager].mode) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)contactButtonClicked
{
    [self.historyView hide];
    
    [self checkAddressBookAuthorization:^(BOOL isAuthorized) {
        if (isAuthorized) {
            [self callAddressBook];
        }
    }];
}

#pragma mark - Notification
- (void)phoneRechargeSuccess
{
    NSMutableArray *vcArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (NSInteger i = vcArray.count - 2; i > 0; i--) {
        UIViewController *vc = vcArray[i];
        if ([vc isKindOfClass:[self class]]) {
            break;
        } else {
            [vcArray removeObject:vc];
        }
    }
    [self.navigationController setViewControllers:vcArray];
    
    [XTPhoneRechargeHistoryView addHistoryWithPhoneNumber:[self sanitizePhoneNumber:self.phoneNumberTextField.text] name:_name detail:_detail];
    
    [_historyView removeFromSuperview];
    _historyView = nil;
    
    self.phoneNumberTextField.text = @"";
    self.tipLabel.textColor = XTBrandGrayColor;
    self.tipLabel.text = @"";
    
    [self setupPriceButtonsWithDataArray:nil enabled:NO];
}

#pragma mark - Private
- (void)initView
{
    [self.topView addSubview:self.phoneNumberTextField];
    [self.topView addSubview:self.tipLabel];
    [self.topView addSubview:self.contactButton];
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.bottomView];
    
    [self setupPriceButtonsWithDataArray:nil enabled:NO];
}

- (void)setupPriceButtonsWithDataArray:(NSArray *)dataArray enabled:(BOOL)enabled
{
    if (dataArray == nil || dataArray.count == 0) {
        NSArray *defaultArray = @[@{@"facePrice" : @"50", @"salePrice" : @"50"},
                                  @{@"facePrice" : @"100", @"salePrice" : @"100"},
                                  @{@"facePrice" : @"200", @"salePrice" : @"200"},
                                  @{@"facePrice" : @"300", @"salePrice" : @"300"},
                                  @{@"facePrice" : @"500", @"salePrice" : @"500"}];
        NSMutableArray *tempDataArray = [[NSMutableArray alloc] initWithCapacity:defaultArray.count];
        [defaultArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
            XTPhonePriceModel *model = [[XTPhonePriceModel alloc] init];
            model.facePrice = dict[@"facePrice"];
            model.salePrice = dict[@"salePrice"];
            [tempDataArray addObject:model];
        }];
        
        dataArray = [NSArray arrayWithArray:tempDataArray];
    }
    
    [self removePriceButtons];
    
    CGFloat margin = 15.0;  // 边距
    CGFloat spacing = 15.0; // 间距
    CGFloat width = (CGRectGetWidth(self.bottomView.bounds) - margin * 2 - spacing * 2) / 3;
    CGFloat height = 70.0;
    
    [dataArray enumerateObjectsUsingBlock:^(XTPhonePriceModel *model, NSUInteger idx, BOOL *stop) {
        NSUInteger row = idx / 3;
        NSUInteger col = idx % 3;
        
        NSString *facePrice = [NSString stringWithFormat:@"%i元", (int)[model.facePrice integerValue]];
        NSString *salePrice = @"";
        if (model.salePrice.length > 0) {
            salePrice = [NSString stringWithFormat:@"售价:%.2f元", [model.salePrice floatValue]];
        }
        
        XTPhonePriceButton *priceButton = [[XTPhonePriceButton alloc] initWithFacePrice:facePrice salePrice:salePrice];
        priceButton.frame = CGRectMake(margin + col * (width + spacing), 52.0 + row * (height + spacing), width, height);
        priceButton.tag = idx + 1;
        priceButton.enabled = enabled;
        [priceButton addTarget:self action:@selector(priceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:priceButton];
        [_priceButtonArray addObject:priceButton];
    }];
}

- (void)removePriceButtons
{
    if (_priceButtonArray.count > 0) {
        for (XTPhonePriceButton *btn in _priceButtonArray) {
            [btn removeFromSuperview];
        }
    }
    
    _priceButtonArray = [NSMutableArray array];
}

- (void)priceButtonClick:(UIButton *)button
{
    [self.view endEditing:YES];
    
    if (XTIsReachable) {
        [self showLoading];
        
        XTPhonePriceModel *model = _phoneGoodsArray[button.tag - 1];
        NSString *goodsId = model.goodsId;
        NSString *realAmount = model.salePrice;
        NSString *rechargeAmount = model.facePrice;
        NSString *payPhone = [XTModulesManager sharedManager].phone;
        NSString *rechargePhone = [self sanitizePhoneNumber:self.phoneNumberTextField.text];
        
        XTWeakSelf(weakSelf);
        [[XTPhoneRechargeApi sharedAPI] postGetPhoneOrderWithGoodId:goodsId realAmount:realAmount rechargeAmount:rechargeAmount payPhone:payPhone rechargePhone:rechargePhone completionHandler:^(XTPhoneRechargeOrderModel *output, NSError *error) {
            [weakSelf hideLoading];
            
            if (!error) {
                XTOrder *order = [[XTOrder alloc] init];
                order.orderType = 0;
                order.orderId = output.orderId;
                order.amount = realAmount;
                [XTNotificationCenter postNotificationName:XTLifeServicePlaceOrderDidSuccessNotification object:order];
            }
        }];
    } else {
        [self showToastWithText:XTNetworkUnavailable];
    }
}

- (void)checkAddressBookAuthorization:(void (^)(BOOL isAuthorized))block
{
    if (@available(iOS 9.0, *)) {
        CNAuthorizationStatus authStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if (CNAuthorizationStatusNotDetermined == authStatus) {
            CNContactStore *contactStore = [[CNContactStore alloc] init];
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError *error) {
                if (!error) {
                    block(granted);
                }
            }];
        } else if (CNAuthorizationStatusAuthorized == authStatus) {
            block(YES);
        } else {
            [self showAuthorizationAlert:@"请在iPhone的“设置-盛京通”选项中，允许访问您的通讯录。"];
        }
    } else {
        ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
        if (kABAuthorizationStatusNotDetermined == authStatus) {
            ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, NULL), ^(bool granted, CFErrorRef error) {
                if (!error) {
                    block(granted);
                }
            });
        } else if (kABAuthorizationStatusAuthorized == authStatus) {
            block(YES);
        } else {
            [self showAuthorizationAlert:@"请在iPhone的“设置-盛京通”选项中，允许访问您的通讯录。"];
        }
    }
}

- (void)callAddressBook
{
    if (@available(iOS 9.0, *)) {
        CNContactPickerViewController *contactPicker = [[CNContactPickerViewController alloc] init];
        contactPicker.delegate = self;
        contactPicker.displayedPropertyKeys = @[CNContactPhoneNumbersKey];
        [self presentViewController:contactPicker animated:YES completion:nil];
    } else {
        ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
        peoplePicker.peoplePickerDelegate = self;
        peoplePicker.displayedProperties = @[[NSNumber numberWithInt:kABPersonPhoneProperty]];
        [self presentViewController:peoplePicker animated:YES completion:nil];
    }
}

- (NSString *)sanitizePhoneNumber:(NSString *)phoneNumber
{
    if (phoneNumber.length == 0) {
        return nil;
    }
    
    NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:XTDigitalCharacterSet] invertedSet];
    NSString *sanitizedPhoneNumber = [[phoneNumber componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
    
    return sanitizedPhoneNumber;
}

- (NSString *)formatPhoneNumber:(NSString *)phoneNumber
{
    if (phoneNumber.length == 0) {
        return nil;
    }
    
    NSMutableString *formattedPhoneNumber = [NSMutableString stringWithString:[self sanitizePhoneNumber:phoneNumber]];
    if (formattedPhoneNumber.length > 3) {
        [formattedPhoneNumber insertString:@" " atIndex:3];
    }
    if (formattedPhoneNumber.length > 8) {
        [formattedPhoneNumber insertString:@" " atIndex:8];
    }
    
    return formattedPhoneNumber;
}

- (void)phoneNumberChanged:(UITextField *)textField
{
    self.tipLabel.textColor = XTBrandGrayColor;
    self.tipLabel.text = @"";
    
    NSString *phoneNumber = [self sanitizePhoneNumber:textField.text];
    if ((phoneNumber.length == XTPhoneNumberLength)) {
        if ([XTAppUtils isMobile:phoneNumber]) {
            [self.view endEditing:YES];
            
            [self.historyView hide];
            
            [self requestWithPhoneNumber:phoneNumber name:nil];
        } else {
            self.tipLabel.textColor = XTBrandRedColor;
            self.tipLabel.text = @"手机号格式不正确";
            
            [self setupPriceButtonsWithDataArray:nil enabled:NO];
        }
    } else if (phoneNumber.length < XTPhoneNumberLength) {
        [self setupPriceButtonsWithDataArray:nil enabled:NO];
    }
}

- (void)requestWithPhoneNumber:(NSString *)phoneNumber name:(NSString *)name
{
    _name = [name copy];
    
    if (XTIsReachable) {
        [self showLoading];
        
        XTWeakSelf(weakSelf);
        [[XTPhoneRechargeApi sharedAPI] postQueryPhoneGoodsWithPhone:phoneNumber completionHandler:^(XTPhoneModel *output, NSError *error) {
            [weakSelf hideLoading];
            
            if (!error) {
                if (output.code.integerValue == 101) {
                    weakSelf.tipLabel.textColor = XTBrandRedColor;
                    weakSelf.tipLabel.text = @"暂不支持此号码充值";
                    
                    [weakSelf setupPriceButtonsWithDataArray:nil enabled:NO];
                } else {
                    _detail = [NSString stringWithFormat:@"%@%@", output.provinceName, output.isp];
                    
                    weakSelf.tipLabel.textColor = XTBrandGrayColor;
                    if (_name.length > 0) {
                        weakSelf.tipLabel.text = [NSString stringWithFormat:@"%@(%@)", _name, _detail];
                    } else {
                        weakSelf.tipLabel.text = [NSString stringWithFormat:@"%@", _detail];
                    }
                    
                    _phoneGoodsArray = [NSArray arrayWithArray:output.phoneGoods];
                    if (_phoneGoodsArray.count == 0) {
                        [weakSelf setupPriceButtonsWithDataArray:nil enabled:NO];
                    } else {
                        [weakSelf setupPriceButtonsWithDataArray:_phoneGoodsArray enabled:YES];
                    }
                }
            }
        }];
    } else {
        [self showToastWithText:XTNetworkUnavailable];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (!self.historyView.superview) {
        [self.view addSubview:self.historyView];
        [self.view bringSubviewToFront:self.historyView];
    }
    [self.historyView show];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.tipLabel.textColor = XTBrandGrayColor;
    self.tipLabel.text = @"";
    
    NSString *phoneNumber = [self sanitizePhoneNumber:textField.text];
    if (phoneNumber.length == XTPhoneNumberLength) {
        if (![XTAppUtils isMobile:phoneNumber]) {
            self.tipLabel.textColor = XTBrandRedColor;
            self.tipLabel.text = @"手机号格式不正确";
            
            [self setupPriceButtonsWithDataArray:nil enabled:NO];
        }
    }
    
    NSString *text = textField.text;

    if ([string isEqualToString:@""]) {
        if (range.length == 1) {
            if (range.location == text.length - 1) {
                if ([text characterAtIndex:text.length - 1] == ' ') {
                    [textField deleteBackward];
                }
                
                return YES;
            } else {
                NSInteger offset = range.location;
                
                if (range.location < text.length && [text characterAtIndex:range.location] == ' ' && [textField.selectedTextRange isEmpty]) {
                    [textField deleteBackward];
                    offset--;
                }
                
                [textField deleteBackward];
                textField.text = [self formatPhoneNumber:textField.text];
                
                UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
                textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
                
                return NO;
            }
        } else if (range.length > 1) {
            BOOL isLast = NO;
            if (range.location + range.length == textField.text.length) {
                isLast = YES;
            }
            
            [textField deleteBackward];
            textField.text = [self formatPhoneNumber:textField.text];
            
            NSInteger offset = range.location;
            if (range.location == 3 || range.location == 8) {
                offset++;
            }
            if (!isLast) {
                UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
                textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
            }
            
            return NO;
        } else {
            return YES;
        }
    } else if (string.length > 0) {
        if ([self sanitizePhoneNumber:textField.text].length + string.length - range.length > XTPhoneNumberLength) {
            return NO;
        }

        [textField insertText:string];
        textField.text = [self formatPhoneNumber:textField.text];
        
        NSInteger offset = range.location + string.length;
        if (range.location == 3 || range.location == 8) {
            offset++;
        }
        UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
        textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
        
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    ABMutableMultiValueRef multiValue = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    NSString *phoneNumber = [self sanitizePhoneNumber:(__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(multiValue, ABMultiValueGetIndexForIdentifier(multiValue, identifier))];
    ABMutableMultiValueRef firstNameValue = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *firstName = (__bridge NSString *)(firstNameValue);
    ABMutableMultiValueRef lastNameValue = ABRecordCopyValue(person, kABPersonLastNameProperty);
    NSString *lastName = (__bridge NSString *)(lastNameValue);
    NSString *name = [NSString stringWithFormat:@"%@%@", firstName, lastName];

    [self dismissViewControllerAnimated:YES completion:^{
        self.phoneNumberTextField.text = [self formatPhoneNumber:phoneNumber];
        
        if ([XTAppUtils isMobile:phoneNumber]) {
            self.tipLabel.textColor = XTBrandGrayColor;
            self.tipLabel.text = @"";
            
            [self requestWithPhoneNumber:phoneNumber name:name];
        } else {
            self.tipLabel.textColor = XTBrandRedColor;
            self.tipLabel.text = @"手机号格式不正确";
            
            [self setupPriceButtonsWithDataArray:nil enabled:NO];
        }
    }];
}

#pragma mark - CNContactPickerDelegate
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty
{
    CNPhoneNumber *phoneNumberValue = (CNPhoneNumber *)contactProperty.value;
    NSString *phoneNumber = [self sanitizePhoneNumber:phoneNumberValue.stringValue];
    NSString *name = [NSString stringWithFormat:@"%@%@", contactProperty.contact.familyName, contactProperty.contact.givenName];
    
    self.phoneNumberTextField.text = [self formatPhoneNumber:phoneNumber];
    
    if ([XTAppUtils isMobile:phoneNumber]) {
        self.tipLabel.textColor = XTBrandGrayColor;
        self.tipLabel.text = @"";
        [self requestWithPhoneNumber:phoneNumber name:name];
    } else {
        self.tipLabel.textColor = XTBrandRedColor;
        self.tipLabel.text = @"手机号格式不正确";
        [self setupPriceButtonsWithDataArray:nil enabled:NO];
    }
}

#pragma mark - XTPhoneRechargeHistoryViewDelegate
- (void)phoneRechargeHistoryView:(XTPhoneRechargeHistoryView *)phoneRechargeHistoryView didSelectPhoneNumber:(NSString *)phoneNumber name:(NSString *)name
{
    [self.view endEditing:YES];
    
    self.phoneNumberTextField.text = [self formatPhoneNumber:phoneNumber];
    
    if ([XTAppUtils isMobile:phoneNumber]) {
        self.tipLabel.textColor = XTBrandGrayColor;
        self.tipLabel.text = @"";
        
        [self requestWithPhoneNumber:phoneNumber name:name];
    } else {
        self.tipLabel.textColor = XTBrandRedColor;
        self.tipLabel.text = @"手机号格式不正确";
        
        [self setupPriceButtonsWithDataArray:nil enabled:NO];
    }
}

- (void)phoneRechargeHistoryViewDidSelectCancel:(XTPhoneRechargeHistoryView *)phoneRechargeHistoryView
{
    [self.view endEditing:YES];
}

#pragma mark - Getter
- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, XTMainScreenWidth, 100.0)];
        _topView.backgroundColor = [UIColor whiteColor];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0.0, CGRectGetHeight(_topView.bounds) - 1.0, CGRectGetWidth(_topView.bounds), 1.0)];
        bottomLine.backgroundColor = XTSeparatorColor;
        [_topView addSubview:bottomLine];
    }
    
    return _topView;
}

- (UITextField *)phoneNumberTextField
{
    if (!_phoneNumberTextField) {
        _phoneNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(15.0, 23.0, 250.0, 40.0)];
        _phoneNumberTextField.backgroundColor = [UIColor clearColor];
        _phoneNumberTextField.delegate = self;
        _phoneNumberTextField.keyboardType = UIKeyboardTypePhonePad;
        _phoneNumberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneNumberTextField.font = XTFont(30.0);
        _phoneNumberTextField.textColor = XTBrandBlackColor;
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"请输入手机号码" attributes:@{NSForegroundColorAttributeName:XTColorFromHex(0xCCCCCC), NSFontAttributeName:XTFont(30.0)}];
        _phoneNumberTextField.attributedPlaceholder = attributedString;
        
        [_phoneNumberTextField addTarget:self action:@selector(phoneNumberChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    
    return _phoneNumberTextField;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.phoneNumberTextField.frame), CGRectGetMaxY(self.phoneNumberTextField.frame) + 5.0, 250.0, 27.0)];
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.font = XTFont(12.0);
        _tipLabel.textColor = XTBrandGrayColor;
    }
    
    return _tipLabel;
}

- (UIButton *)contactButton
{
    if (!_contactButton) {
        _contactButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.topView.bounds) - 15.0 - 29.0, 30.0, 29.0, 29.0)];
        _contactButton.backgroundColor = [UIColor clearColor];
        [_contactButton setBackgroundImage:[UIImage imageNamed:XTModulesSDKImage(@"select_contact")] forState:UIControlStateNormal];
        [_contactButton addTarget:self action:@selector(contactButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _contactButton;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(self.topView.frame), XTMainScreenWidth, XTNonTopLevelViewHeight - CGRectGetHeight(self.topView.bounds))];
        _bottomView.backgroundColor = [UIColor clearColor];
        
        UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 20.0, 70.0, 22.0)];
        headLabel.backgroundColor = [UIColor clearColor];
        headLabel.font = XTFont(16.0);
        headLabel.textColor = XTBrandGrayColor;
        headLabel.text = @"充话费";
        [_bottomView addSubview:headLabel];
    }
    
    return _bottomView;
}

- (XTPhoneRechargeHistoryView *)historyView
{
    if (!_historyView) {
        _historyView = [[XTPhoneRechargeHistoryView alloc] initWithFrame:CGRectMake(0.0, 100.0, XTMainScreenWidth, XTNonTopLevelViewHeight - 100.0)];
        _historyView.delegate = self;
    }
    
    return _historyView;
}

@end
