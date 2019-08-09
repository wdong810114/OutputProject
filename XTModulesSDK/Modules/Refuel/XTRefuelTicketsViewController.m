//
//  XTRefuelTicketsViewController.m
//  XTModulesSDK
//
//  Created by wdd on 2019/8/8.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTRefuelTicketsViewController.h"

@interface XTRefuelTicketsViewController ()

@end

@implementation XTRefuelTicketsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的油券";
    [self setLeftBarButtonItem:@selector(backButtonClicked) image:@"back_icon_n" highlightedImage:@"back_icon_h"];
}

#pragma mark - Button
- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
