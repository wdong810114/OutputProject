//
//  XTLifePaymentPayBillViewController.m
//  XTModulesSDK
//
//  Created by wdd on 2019/8/15.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTLifePaymentPayBillViewController.h"

@interface XTLifePaymentPayBillViewController ()

@end

@implementation XTLifePaymentPayBillViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"生活缴费";
    [self setLeftBarButtonItem:@selector(backButtonClicked) image:@"back_icon_n" highlightedImage:@"back_icon_h"];
}

#pragma mark - Button
- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end