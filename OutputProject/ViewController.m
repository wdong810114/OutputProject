//
//  ViewController.m
//  OutputProject
//
//  Created by wdd on 2019/7/22.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "ViewController.h"

#import "XTModulesManager.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *phoneRechargeButton;
@property (nonatomic, strong) UIButton *refuelButton;
@property (nonatomic, strong) UIButton *lifePaymentButton;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.phoneRechargeButton];
    [self.view addSubview:self.refuelButton];
    [self.view addSubview:self.lifePaymentButton];
}

#pragma mark - Action
- (void)phoneRecharge
{
    [[XTModulesManager sharedManager] showPhoneRechargeWithSourceVC:self mode:XTModuleShowModePresent accessKey:@"123456" userId:@"111111" phone:@"18640048241"];
}

- (void)refuel
{
    [[XTModulesManager sharedManager] showRefuelWithSourceVC:self mode:XTModuleShowModePresent accessKey:@"123456" userId:@"111111" phone:@"18640048241"];
}

- (void)lifePayment
{
    [[XTModulesManager sharedManager] showLifePaymentWithSourceVC:self mode:XTModuleShowModePresent accessKey:@"123456" userId:@"111111" phone:@"18640048241"];
}

#pragma mark - Getter
- (UIButton *)phoneRechargeButton
{
    if (!_phoneRechargeButton) {
        _phoneRechargeButton = [[UIButton alloc] initWithFrame:CGRectMake(10.0, 60.0, CGRectGetWidth(self.view.bounds) - 20.0, 45.0)];
        _phoneRechargeButton.backgroundColor = [UIColor clearColor];
        _phoneRechargeButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_phoneRechargeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_phoneRechargeButton setTitle:@"话费充值" forState:UIControlStateNormal];
        [_phoneRechargeButton addTarget:self action:@selector(phoneRecharge) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _phoneRechargeButton;
}

- (UIButton *)refuelButton
{
    if (!_refuelButton) {
        _refuelButton = [[UIButton alloc] initWithFrame:CGRectMake(10.0, CGRectGetMaxY(self.phoneRechargeButton.frame) + 20.0, CGRectGetWidth(self.view.bounds) - 20.0, 45.0)];
        _refuelButton.backgroundColor = [UIColor clearColor];
        _refuelButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_refuelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_refuelButton setTitle:@"特惠加油" forState:UIControlStateNormal];
        [_refuelButton addTarget:self action:@selector(refuel) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _refuelButton;
}

- (UIButton *)lifePaymentButton
{
    if (!_lifePaymentButton) {
        _lifePaymentButton = [[UIButton alloc] initWithFrame:CGRectMake(10.0, CGRectGetMaxY(self.refuelButton.frame) + 20.0, CGRectGetWidth(self.view.bounds) - 20.0, 45.0)];
        _lifePaymentButton.backgroundColor = [UIColor clearColor];
        _lifePaymentButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_lifePaymentButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_lifePaymentButton setTitle:@"生活缴费" forState:UIControlStateNormal];
        [_lifePaymentButton addTarget:self action:@selector(lifePayment) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _lifePaymentButton;
}

@end
