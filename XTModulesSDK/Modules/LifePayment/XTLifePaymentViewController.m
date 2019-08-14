//
//  XTLifePaymentViewController.m
//  XTModulesSDK
//
//  Created by wdd on 2019/8/13.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTLifePaymentViewController.h"

#import "XTLifePaymentApi.h"

@interface XTLifePaymentViewController ()

@end

@implementation XTLifePaymentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"生活缴费";
    [self setLeftBarButtonItem:@selector(backButtonClicked) image:@"back_icon_n" highlightedImage:@"back_icon_h"];
}

- (void)backButtonClicked
{
    if (XTModuleShowModePush == [XTModulesManager sharedManager].mode) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
