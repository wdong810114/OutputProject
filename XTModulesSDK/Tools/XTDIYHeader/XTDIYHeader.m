//
//  XTDIYHeader.m
//  XTUIModuleSDK
//
//  Created by wdd on 2017/6/22.
//  Copyright © 2017年 NewSky Payment. All rights reserved.
//

#import "XTDIYHeader.h"

@interface XTDIYHeader ()

@end

@implementation XTDIYHeader

#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    
    self.stateLabel.hidden = YES;
    self.lastUpdatedTimeLabel.hidden = YES;
}

@end
