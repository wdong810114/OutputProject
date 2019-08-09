//
//  UIView+XTExtension.m
//  XTModulesSDK
//
//  Created by wdd on 2019/7/31.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "UIView+XTExtension.h"

@implementation UIView (XTExtension)

- (void)setXt_x:(CGFloat)xt_x
{
    CGRect frame = self.frame;
    frame.origin.x = xt_x;
    self.frame = frame;
}

- (CGFloat)xt_x
{
    return self.frame.origin.x;
}

- (void)setXt_y:(CGFloat)xt_y
{
    CGRect frame = self.frame;
    frame.origin.y = xt_y;
    self.frame = frame;
}

- (CGFloat)xt_y
{
    return self.frame.origin.y;
}

- (void)setXt_w:(CGFloat)xt_w
{
    CGRect frame = self.frame;
    frame.size.width = xt_w;
    self.frame = frame;
}

- (CGFloat)xt_w
{
    return self.frame.size.width;
}

- (void)setXt_h:(CGFloat)xt_h
{
    CGRect frame = self.frame;
    frame.size.height = xt_h;
    self.frame = frame;
}

- (CGFloat)xt_h
{
    return self.frame.size.height;
}

- (void)setXt_size:(CGSize)xt_size
{
    CGRect frame = self.frame;
    frame.size = xt_size;
    self.frame = frame;
}

- (CGSize)xt_size
{
    return self.frame.size;
}

- (void)setXt_origin:(CGPoint)xt_origin
{
    CGRect frame = self.frame;
    frame.origin = xt_origin;
    self.frame = frame;
}

- (CGPoint)xt_origin
{
    return self.frame.origin;
}

@end
