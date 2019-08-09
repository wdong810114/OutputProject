//
//  XTDIYHeader.m
//  XTUIModuleSDK
//
//  Created by wdd on 2017/6/22.
//  Copyright © 2017年 NewSky Payment. All rights reserved.
//

#import "XTDIYHeader.h"

#import "XTMacro.h"

@interface XTDIYHeader ()
{
    __unsafe_unretained UIImageView *_gifView;
}

/** 所有状态对应的动画图片 */
@property (nonatomic, strong) NSMutableDictionary *stateImages;
/** 所有状态对应的动画时间 */
@property (nonatomic, strong) NSMutableDictionary *stateDurations;

- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MJRefreshState)state;
- (void)setImages:(NSArray *)images forState:(MJRefreshState)state;

@end

@implementation XTDIYHeader

#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    
    self.mj_h = 70.0;
    
    self.stateLabel.hidden = YES;
    self.lastUpdatedTimeLabel.hidden = YES;
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i <= 50; i++) {
        NSString *name = [NSString stringWithFormat:@"refresh_header_dragging%02lu", (unsigned long)i];
        UIImage *image = [UIImage imageNamed:XTModulesSDKImage(name)];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置正在刷新状态的动画图片
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i <= 60; i++) {
        NSString *name = [NSString stringWithFormat:@"refresh_header_loading%02lu", (unsigned long)i];
        UIImage *image = [UIImage imageNamed:XTModulesSDKImage(name)];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages duration:1.0 forState:MJRefreshStatePulling];
    [self setImages:refreshingImages duration:1.0 forState:MJRefreshStateRefreshing];
}

- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
    NSArray *images = self.stateImages[@(MJRefreshStateIdle)];
    if (self.state != MJRefreshStateIdle || images.count == 0) return;
    
    [self.gifView stopAnimating];
    
    // 设置当前需要显示的图片
    UIImage *image = images[0];
    NSUInteger animationStartOffset = (self.mj_h - image.size.height) / 2 + 1.0 + 10.0;
    NSUInteger animationEndOffset = (self.mj_h + image.size.height) / 2 + 10.0;
    NSUInteger pullingOffset = self.mj_h * pullingPercent;
    NSUInteger index;
    if (pullingOffset <= animationStartOffset) {
        index = 0;
    } else if (pullingOffset >= animationEndOffset) {
        index = images.count - 1;
    } else {
        index = pullingOffset - animationStartOffset;
    }
    self.gifView.image = images[index];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.gifView.constraints.count > 0) return;
    
    self.gifView.frame = self.bounds;
    if (self.stateLabel.hidden && self.lastUpdatedTimeLabel.hidden) {
        self.gifView.contentMode = UIViewContentModeCenter;
    } else {
        self.gifView.contentMode = UIViewContentModeRight;
        
        CGFloat stateWidth = self.stateLabel.mj_textWith;
        CGFloat timeWidth = 0.0;
        if (!self.lastUpdatedTimeLabel.hidden) {
            timeWidth = self.lastUpdatedTimeLabel.mj_textWith;
        }
        CGFloat textWidth = MAX(stateWidth, timeWidth);
        self.gifView.mj_w = self.mj_w * 0.5 - textWidth * 0.5 - self.labelLeftInset;
    }
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态做事情
    switch (state) {
        case MJRefreshStateIdle:
            [self.gifView stopAnimating];
            break;
        case MJRefreshStatePulling:
        case MJRefreshStateRefreshing:
        {
            NSArray *images = self.stateImages[@(state)];
            if (images.count > 0) {
                [self.gifView stopAnimating];
                
                if (images.count == 1) {
                    self.gifView.image = images[0];
                } else {
                    self.gifView.animationImages = images;
                    self.gifView.animationDuration = [self.stateDurations[@(state)] doubleValue];
                    [self.gifView startAnimating];
                }
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 私有方法
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MJRefreshState)state
{
    if (!images || images.count == 0) return;
    
    self.stateImages[@(state)] = images;
    self.stateDurations[@(state)] = @(duration);
    
    // 根据图片设置控件的高度
    UIImage *image = images[0];
    if (image.size.height + 20.0 > self.mj_h) {
        self.mj_h = image.size.height + 20.0;
    }
}

- (void)setImages:(NSArray *)images forState:(MJRefreshState)state
{
    [self setImages:images duration:images.count * 0.1 forState:state];
}

#pragma mark - 懒加载
- (UIImageView *)gifView
{
    if (!_gifView) {
        UIImageView *gifView = [[UIImageView alloc] init];
        [self addSubview:_gifView = gifView];
    }
    
    return _gifView;
}

- (NSMutableDictionary *)stateImages
{
    if (!_stateImages) {
        _stateImages = [NSMutableDictionary dictionary];
    }
    
    return _stateImages;
}

- (NSMutableDictionary *)stateDurations
{
    if (!_stateDurations) {
        _stateDurations = [NSMutableDictionary dictionary];
    }
    
    return _stateDurations;
}

@end
