//
//  XTRefuelTicketDetailViewController.m
//  XTModulesSDK
//
//  Created by wdd on 2019/8/9.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTRefuelTicketDetailViewController.h"

@interface XTRefuelTicketDetailViewController ()

@end

@implementation XTRefuelTicketDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"加油券详情";
    [self setLeftBarButtonItem:@selector(backButtonClicked) image:@"back_icon_n" highlightedImage:@"back_icon_h"];
}

#pragma mark - Button
- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
