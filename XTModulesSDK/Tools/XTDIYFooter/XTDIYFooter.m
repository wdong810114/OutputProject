//
//  XTDIYFooter.m
//  XTUIModuleSDK
//
//  Created by wdd on 2017/6/22.
//  Copyright © 2017年 NewSky Payment. All rights reserved.
//

#import "XTDIYFooter.h"

@implementation XTDIYFooter

#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    
    [self setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [self setTitle:@"释放加载更多" forState:MJRefreshStatePulling];
    [self setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [self setTitle:@"加载中..." forState:MJRefreshStateWillRefresh];
    [self setTitle:@"已是最后一页" forState:MJRefreshStateNoMoreData];
}

@end
