//
//  XTAlertView.m
//  HappyPay
//
//  Created by wdd on 2018/8/7.
//  Copyright © 2018年 NewSky. All rights reserved.
//

#import "XTAlertView.h"

#import "XTMacro.h"
#import "XTAppUtils.h"

NSString *const XTAlertViewWillShowNotification    = @"XTAlertViewWillShowNotification";
NSString *const XTAlertViewDidShowNotification     = @"XTAlertViewDidShowNotification";
NSString *const XTAlertViewWillDismissNotification = @"XTAlertViewWillDismissNotification";
NSString *const XTAlertViewDidDismissNotification  = @"XTAlertViewDidDismissNotification";

#pragma mark - XTAlertItem
@interface XTAlertItem : NSObject

/** 按钮标题 */
@property (nonatomic, copy) NSString *title;
/** 按钮风格 */
@property (nonatomic, assign) XTAlertViewButtonType type;
/** 对应按钮行动的处理 */
@property (nonatomic, copy) XTAlertViewHandler action;

@end

@implementation XTAlertItem

@end



#pragma mark - XTAlertViewController
@interface XTAlertViewController : UIViewController

@property (nonatomic, assign) BOOL allowRotation;

@end

@implementation XTAlertViewController

- (instancetype)initWithAllowRotation:(BOOL)allowRotation
{
    if (self = [super init]) {
        self.allowRotation = allowRotation;
    }
    
    return self;
}

- (BOOL)shouldAutorotate
{
    return self.allowRotation;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (self.allowRotation) {
        return UIInterfaceOrientationMaskAll;
    }
    
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end



#pragma mark - XTAlertWindow
@interface XTAlertWindow : UIWindow

/** Alert背景视图风格 */
@property (nonatomic, assign) XTAlertViewBackgroundStyle style;

@end

@implementation XTAlertWindow

- (instancetype)initWithFrame:(CGRect)frame style:(XTAlertViewBackgroundStyle)style
{
    if (self = [super initWithFrame:frame]) {
        self.style = style;
        self.opaque = NO;
        self.windowLevel = UIWindowLevelAlert;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    switch (self.style) {
        case XTAlertViewBackgroundStyleGradient:
        {
            size_t locationsCount = 2;
            CGFloat locations[2] = {0.0, 1.0};
            CGFloat colors[8] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.75};
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
            CGColorSpaceRelease(colorSpace);
            
            CGPoint center = CGPointMake(CGRectGetWidth(self.bounds) * 0.5, CGRectGetHeight(self.bounds) * 0.5);
            CGFloat radius = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
            CGContextDrawRadialGradient(context, gradient, center, 0.0, center, radius, kCGGradientDrawsAfterEndLocation);
            CGGradientRelease(gradient);
        }
            break;
            
        case XTAlertViewBackgroundStyleSolid:
        {
            [[[UIColor blackColor] colorWithAlphaComponent:0.5] set];
            CGContextFillRect(context, self.bounds);
        }
            break;
            
        default:
            break;
    }
}

@end



#pragma mark - XTAlertView
@interface XTAlertView () <CAAnimationDelegate>

/** 是否动画 */
@property (nonatomic, assign, getter = isAlertAnimating) BOOL alertAnimating;
/** 是否可见 */
@property (nonatomic, assign, getter = isVisible) BOOL visible;
/** Label容器视图 */
@property (nonatomic, weak) UIView *containerLabelView;
/** 标题 */
@property (nonatomic, weak) UILabel *titleLabel;
/** 消息描述 */
@property (nonatomic, weak) UILabel *messageLabel;
/** 容器视图 */
@property (nonatomic, weak) UIView *containerView;
/** 存放行动items */
@property (nonatomic, strong) NSMutableArray *items;
/** 存放按钮 */
@property (nonatomic, strong) NSMutableArray *buttons;
/** 展示的背景Window */
@property (nonatomic, strong) XTAlertWindow *alertWindow;

@end

@implementation XTAlertView

+ (void)initialize
{
    if (self != [XTAlertView class]) return;
    
    // 设置整体默认外观
    XTAlertView *appearance = [self appearance];
    appearance.viewBackgroundColor = [UIColor whiteColor];
    appearance.titleColor = XTBrandBlackColor;
    appearance.messageColor = XTBrandLightBlackColor;
    appearance.titleFont = XTFont(16.0);
    appearance.messageFont = XTFont(12.0);
    appearance.buttonFont = XTFont(12.0);
    appearance.defaultButtonTitleColor = [UIColor whiteColor];
    appearance.cancelButtonTitleColor = XTBrandGrayColor;
    appearance.cornerRadius = 5.0;
}

- (void)dealloc
{
    [XTNotificationCenter removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.frame = XTMainScreenBounds;
        [self createSubviews];
    }
    
    return self;
}

- (void)supportRotating
{
    [XTNotificationCenter addObserver:self
                             selector:@selector(statusBarOrientationChange:)
                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                               object:nil];
}

- (void)statusBarOrientationChange:(NSNotification *)notification
{
    self.frame = XTMainScreenBounds;
    [self updateSubviewsFrame];
}

+ (instancetype)alertViewWithTitle:(NSString *)title message:(NSString *)message
{
    return [[self alloc] initWithTitle:title message:message];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message
{
    XTAlertView *alertView = [[[self class] alloc] init];
    alertView.title = title;
    alertView.message = message;
    alertView.items = [[NSMutableArray alloc] init];
    
    return alertView;
}

- (void)addButtonWithTitle:(NSString *)title type:(XTAlertViewButtonType)type handler:(XTAlertViewHandler)handler
{
    XTAlertItem *item = [[XTAlertItem alloc] init];
    item.title = title;
    item.type = type;
    item.action = handler;
    [self.items addObject:item];
}

- (void)show
{
    if (self.isVisible) return;
    if (self.isAlertAnimating) return;
    
    XTWeakSelf(weakSelf);
    if (self.willShowHandler) {
        self.willShowHandler(weakSelf);
    }
    
    [XTNotificationCenter postNotificationName:XTAlertViewWillShowNotification object:self userInfo:nil];
    
    self.visible = YES;
    self.alertAnimating = YES;
    
    [self createButtons]; // 设置按钮
    [self.alertWindow.rootViewController.view addSubview:self];
    [self.alertWindow makeKeyAndVisible];
    [self updateSubviewsFrame]; // 布局
    
    [self transitionInCompletion:^{
        if (weakSelf.didShowHandler) {
            weakSelf.didShowHandler(weakSelf);
        }
        [XTNotificationCenter postNotificationName:XTAlertViewDidShowNotification object:weakSelf userInfo:nil];
        
        weakSelf.alertAnimating = NO;
    }];
    
    if (self.isSupportRotating) {
        [self supportRotating];
    }
}

- (void)removeAlertView
{
    [self dismissAnimated:NO];
}

- (void)dismissAnimated:(BOOL)animated
{
    BOOL isVisible = self.isVisible;
    
    XTWeakSelf(weakSelf);
    if (isVisible) {
        if (self.willDismissHandler) {
            self.willDismissHandler(weakSelf);
        }
        
        [XTNotificationCenter postNotificationName:XTAlertViewWillDismissNotification object:self userInfo:nil];
    }
    
    void (^dismissComplete)(void) = ^{
        weakSelf.visible = NO;
        weakSelf.alertAnimating =  NO;
        
        if (isVisible) {
            if (weakSelf.didDismissHandler) {
                weakSelf.didDismissHandler(weakSelf);
            }
            
            [XTNotificationCenter postNotificationName:XTAlertViewDidDismissNotification object:weakSelf userInfo:nil];
        }
        
        [self removeView];
    };
    
    if (animated && isVisible) {
        self.alertAnimating =  YES;
        [self transitionOutCompletion:dismissComplete];
    } else {
        dismissComplete();
    }
}

#pragma mark - Transitions动画
/**
 *  进入的动画
 */
- (void)transitionInCompletion:(void(^)(void))completion
{
    CGFloat duration = 0.25;
    
    [UIView animateWithDuration:duration animations:^{
        self.alertWindow.alpha = 1.0;
    }];
    
    switch (self.transitionStyle) {
        case XTAlertViewTransitionStyleFade:
        {
            self.containerView.alpha = 0.0;
            
            [UIView animateWithDuration:duration animations:^{
                self.containerView.alpha = 1.0;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
        }
            break;
            
        case XTAlertViewTransitionStyleSlideFromTop:
        {
            CGRect rect = self.containerView.frame;
            CGRect originalRect = rect;
            rect.origin.y = -rect.size.height;
            self.containerView.frame = rect;
            
            [UIView animateWithDuration:duration animations:^{
                self.containerView.frame = originalRect;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
        }
            break;
            
        case XTAlertViewTransitionStyleSlideFromBottom:
        {
            CGRect rect = self.containerView.frame;
            CGRect originalRect = rect;
            rect.origin.y = CGRectGetHeight(self.bounds);
            self.containerView.frame = rect;
            
            [UIView animateWithDuration:duration animations:^{
                self.containerView.frame = originalRect;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
        }
            break;
            
        case XTAlertViewTransitionStyleBounce:
        {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animation.values = @[@(0.01), @(1.2), @(0.9), @(1)];
            animation.keyTimes = @[@(0), @(0.4), @(0.6), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = duration;
            animation.delegate = self;
            [animation setValue:completion forKey:@"handler"];
            [self.containerView.layer addAnimation:animation forKey:@"bounce"];
        }
            break;
            
        case XTAlertViewTransitionStyleDropDown:
        {
            CGFloat y = self.containerView.center.y;
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
            animation.values = @[@(y - CGRectGetHeight(self.bounds)), @(y + 20), @(y - 10), @(y)];
            animation.keyTimes = @[@(0), @(0.5), @(0.75), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = duration;
            animation.delegate = self;
            [animation setValue:completion forKey:@"handler"];
            [self.containerView.layer addAnimation:animation forKey:@"dropdown"];
        }
            break;
            
        default:
            break;
    }
}

/**
 *  消失的动画
 */
- (void)transitionOutCompletion:(void(^)(void))completion
{
    CGFloat duration = 0.25;
    
    switch (self.transitionStyle) {
        case XTAlertViewTransitionStyleFade:
        {
            [UIView animateWithDuration:duration animations:^{
                self.containerView.alpha = 0.0;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
        }
            break;
            
        case XTAlertViewTransitionStyleSlideFromTop:
        {
            CGRect rect = self.containerView.frame;
            rect.origin.y = -rect.size.height;
            
            [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.containerView.frame = rect;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
        }
            break;

        case XTAlertViewTransitionStyleSlideFromBottom:
        {
            CGRect rect = self.containerView.frame;
            rect.origin.y = CGRectGetHeight(self.bounds);
            
            [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.containerView.frame = rect;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
        }
            break;
            
        case XTAlertViewTransitionStyleBounce:
        {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animation.values = @[@(1), @(1.2), @(0.01)];
            animation.keyTimes = @[@(0), @(0.4), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = duration;
            animation.delegate = self;
            [animation setValue:completion forKey:@"handler"];
            [self.containerView.layer addAnimation:animation forKey:@"bounce"];
            
            self.containerView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        }
            break;
            
        case XTAlertViewTransitionStyleDropDown:
        {
            CGPoint point = self.containerView.center;
            point.y += CGRectGetHeight(self.bounds);
            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.containerView.center = point;
                CGFloat angle = ((CGFloat)arc4random_uniform(100) - 50.0) / 100.0;
                self.containerView.transform = CGAffineTransformMakeRotation(angle);
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 布局
- (void)updateSubviewsFrame
{
    CGFloat margin = 25.0;
    CGFloat horizontalMargin = XTiPhone6ScaleWidth(60.0); // 按苹果6为标准做比例
    CGFloat containerViewW = (XTMainScreenWidth - horizontalMargin * 2);
    
    /** 标题 */
    CGSize titleLabelSize = {0.0, 0.0};
    CGFloat titleLabelW = containerViewW - margin * 2;
    
    if (self.title.length > 0) {
        titleLabelSize = [XTAppUtils sizeOfString:self.title font:self.titleLabel.font constrainedToSize:CGSizeMake(titleLabelW, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    CGFloat titleLabelH = titleLabelSize.height;
    CGFloat titleLabelX = margin;
    CGFloat titleLabelY = margin;
    self.titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    
    /** 消息描述 */
    CGSize messageLabelSize = {0.0, 0.0};
    CGFloat messageLabelW = titleLabelW;
    
    if (self.message.length > 0) {
        messageLabelSize = [XTAppUtils sizeOfString:self.message font:self.messageLabel.font constrainedToSize:CGSizeMake(messageLabelW, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    CGFloat messageLabelH = messageLabelSize.height;
    CGFloat messageLabelX = titleLabelX;
    CGFloat messageLabelY = 0.0;
    if (self.title.length > 0) {
        messageLabelY = CGRectGetMaxY(self.titleLabel.frame) + (messageLabelH > 0.0 ? 20.0 : 0.0);
    } else {
        messageLabelY = messageLabelH > 0.0 ? margin : 0.0;
    }
    self.messageLabel.frame = CGRectMake(messageLabelX, messageLabelY, messageLabelW, messageLabelH);
    
    /** 按钮 */
    CGFloat originY = CGRectGetMaxY(self.messageLabel.frame) + margin;
    CGFloat buttonH = 33.0;
    CGFloat buttonY = originY;
    CGFloat buttonMargin = 13.0;
    CGFloat buttonSpacing = 12.0;
    
    if (self.items.count > 0) {
        if (self.items.count == 2 && XTAlertViewButtonsListStyleNormal == self.buttonsListStyle) {
            CGFloat buttonW = (containerViewW - buttonMargin * 2 - buttonSpacing) * 0.5;
            
            UIButton *button = self.buttons[0];
            button.frame = CGRectMake(buttonMargin, buttonY, buttonW, buttonH);
            
            button = self.buttons[1];
            button.frame = CGRectMake(buttonMargin + buttonW + buttonSpacing, buttonY, buttonW, buttonH);
            
            originY += buttonH + 10.0;
        } else {
            for (NSUInteger i = 0; i < self.buttons.count; i++) {
                if (i > 0) {
                    buttonY = originY;
                }
                
                CGFloat buttonW = containerViewW - buttonMargin * 2;
                                   
                UIButton *button = self.buttons[i];
                button.frame = CGRectMake(buttonMargin, buttonY, buttonW, buttonH);
                
                originY += buttonH + 10.0;
            }
        }
    }
    
    /** Label容器视图 */
    CGFloat containerLabelViewW = containerViewW;
    CGFloat containerLabelViewH = CGRectGetMaxY(self.messageLabel.frame) + margin;
    CGFloat containerLabelViewX = 0.0;
    CGFloat containerLabelViewY = 0.0;
    self.containerLabelView.frame = CGRectMake(containerLabelViewX, containerLabelViewY, containerLabelViewW, containerLabelViewH);
    
    /** 容器视图 */
    CGFloat containerViewH = originY;
    CGFloat containerViewX = horizontalMargin;
    CGFloat containerViewY = (CGRectGetHeight(self.bounds) - containerViewH) * 0.5;
    self.containerView.frame = CGRectMake(containerViewX, containerViewY, containerViewW, containerViewH);
}

#pragma mark - 视图相关
- (void)createSubviews
{
    /** 容器视图 */
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.layer.masksToBounds = YES;
    containerView.layer.cornerRadius = self.cornerRadius;
    [containerView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPressContainerView:)]];
    [self addSubview:containerView];
    self.containerView = containerView;
    
    /** Label容器视图 */
    UIView *containerLabelView = [[UIView alloc] init];
    containerLabelView.backgroundColor = [UIColor clearColor];
    [containerView addSubview:containerLabelView];
    self.containerLabelView = containerLabelView;
    
    /** 标题 */
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.numberOfLines = 0;
    titleLabel.font = self.titleFont;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = self.titleColor;
    [self.containerLabelView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    /** 消息描述 */
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.numberOfLines = 0;
    messageLabel.font = self.messageFont;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.textColor = self.messageColor;
    [self.containerLabelView addSubview:messageLabel];
    self.messageLabel = messageLabel;
}

/**
 *  滑动手势处理
 */
- (void)panPressContainerView:(UIPanGestureRecognizer *)recognizer
{
    switch (recognizer.state) {
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            CGPoint location = [recognizer locationInView:self];
            UIButton *btn = [self buttonWithLocation:location];
            if (btn) {
                [self buttonAction:btn];
            }
        }
            break;
            
        default:
            break;
    }
}

/**
 *  遍历手指触摸的点是否在按钮上
 */
- (UIButton *)buttonWithLocation:(CGPoint)location
{
    UIButton *btn = nil;
    
    for (NSUInteger i = 0; i < self.buttons.count; i++) {
        UIButton *tempBtn = self.buttons[i];
        CGRect btnFrame = [tempBtn convertRect:tempBtn.bounds toView:self];
        if (CGRectContainsPoint(btnFrame, location)) {
            tempBtn.highlighted = YES;
            btn = tempBtn;
        } else {
            tempBtn.highlighted = NO;
        }
    }
    
    return btn;
}

- (XTAlertWindow *)alertWindow
{
    if (!_alertWindow) {
        _alertWindow = [[XTAlertWindow alloc] initWithFrame:XTMainScreenBounds style:self.backgroundStyle];
        _alertWindow.rootViewController = [[XTAlertViewController alloc] initWithAllowRotation:self.isSupportRotating];
        _alertWindow.alpha = 0.01;
    }
    
    return _alertWindow;
}

- (void)createButtons
{
    self.buttons = [[NSMutableArray alloc] initWithCapacity:self.items.count];
    
    for (NSUInteger i = 0; i < self.items.count; i++) {
        UIButton *button = [self buttonForItemIndex:i];
        [self.buttons addObject:button];
        [self.containerView addSubview:button];
    }
}

- (UIButton *)buttonForItemIndex:(NSUInteger)index
{
    XTAlertItem *item = self.items[index];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 2.0;
    button.tag = index;
    button.adjustsImageWhenHighlighted = NO;
    button.titleLabel.font = self.buttonFont;
    [button setTitle:item.title forState:UIControlStateNormal];
    
    switch (item.type) {
        case XTAlertViewButtonTypeCancel:
        {
            button.layer.borderWidth = 0.5;
            button.layer.borderColor = XTBrandGrayColor.CGColor;

            [button setTitleColor:self.cancelButtonTitleColor forState:UIControlStateNormal];
            
            [button setBackgroundImage:[XTAppUtils imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            [button setBackgroundImage:[XTAppUtils imageWithColor:[[UIColor blackColor] colorWithAlphaComponent:0.1]] forState:UIControlStateHighlighted];
        }
            break;
            
        case XTAlertViewButtonTypeDefault:
        default:
        {
            [button setTitleColor:self.defaultButtonTitleColor forState:UIControlStateNormal];
            
            CGFloat horizontalMargin = XTiPhone6ScaleWidth(60.0); // 按苹果6为标准做比例
            CGFloat containerViewW = (XTMainScreenWidth - horizontalMargin * 2);
            CGRect buttonBounds = CGRectMake(0.0, 0.0, 0.0, 33.0);
            CGFloat buttonMargin = 13.0;
            CGFloat buttonSpacing = 12.0;
            if (self.items.count == 2 && XTAlertViewButtonsListStyleNormal == self.buttonsListStyle) {
                buttonBounds.size.width = (containerViewW - buttonMargin * 2 - buttonSpacing) * 0.5;
            } else {
                buttonBounds.size.width = containerViewW - buttonMargin * 2;
            }
            
            UIColor *startColor = XTColor(0xb0, 0x9b, 0x86);
            UIColor *endColor = XTColor(0xdf, 0xc2, 0xa6);
            
            UIImage *normalBackgroundImage = [XTAppUtils gradientImageWithBounds:buttonBounds colors:@[startColor, endColor]];
            UIImage *highlightedBackgroundImage = [XTAppUtils gradientImageWithBounds:buttonBounds colors:@[[startColor colorWithAlphaComponent:0.9], [endColor colorWithAlphaComponent:0.9]]];
            [button setBackgroundImage:normalBackgroundImage forState:UIControlStateNormal];
            [button setBackgroundImage:highlightedBackgroundImage forState:UIControlStateHighlighted];
        }
            break;
    }
    
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)removeView
{
    [UIView animateWithDuration:0.25 animations:^{
        self.alertWindow.alpha = 0.01;
    } completion:^(BOOL finished) {
        [self.alertWindow removeFromSuperview];
        self.alertWindow = nil;
        
        while(self.subviews.count) {
            [self.subviews.lastObject removeFromSuperview];
        }
        [self removeFromSuperview];
        
        [XTMainWindow makeKeyAndVisible];
    }];
}

#pragma mark - 按钮点击的行动
- (void)buttonAction:(UIButton *)button
{
    self.alertAnimating = YES;
    
    XTAlertItem *item = self.items[button.tag];
    if (item.action) {
        item.action(self);
    }
    
    [self dismissAnimated:YES];
}

#pragma mark - 动画的代理
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    void(^completion)(void) = [anim valueForKeyPath:@"handler"];
    
    if (completion) {
        completion();
    }
}

#pragma mark - Setter方法
- (void)setTitle:(NSString *)title
{
    if (_title == title) return;
    
    _title = [title copy];
    self.titleLabel.text = title;
}

- (void)setMessage:(NSString *)message
{
    if (_message == message) return;
    
    _message = [message copy];
    self.messageLabel.text = message;
}

- (void)setTitleTextAlignment:(NSTextAlignment)titleTextAlignment
{
    _titleTextAlignment = titleTextAlignment;
    self.titleLabel.textAlignment = titleTextAlignment;
}

- (void)setMessageTextAlignment:(NSTextAlignment)messageTextAlignment
{
    _messageTextAlignment = messageTextAlignment;
    self.messageLabel.textAlignment = messageTextAlignment;
}

- (void)setViewBackgroundColor:(UIColor *)viewBackgroundColor
{
    if (_viewBackgroundColor == viewBackgroundColor) return;
    
    _viewBackgroundColor = viewBackgroundColor;
    self.containerView.backgroundColor = viewBackgroundColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    if (_cornerRadius == cornerRadius) return;
    
    _cornerRadius = cornerRadius;
    self.containerView.layer.cornerRadius = cornerRadius;
}

- (void)setTitleFont:(UIFont *)titleFont
{
    if (_titleFont == titleFont) return;
    
    _titleFont = titleFont;
    self.titleLabel.font = titleFont;
}

- (void)setMessageFont:(UIFont *)messageFont
{
    if (_messageFont == messageFont) return;
    
    _messageFont = messageFont;
    self.messageLabel.font = messageFont;
}

- (void)setTitleColor:(UIColor *)titleColor
{
    if (_titleColor == titleColor) return;
    
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}

- (void)setMessageColor:(UIColor *)messageColor
{
    if (_messageColor == messageColor) return;
    
    _messageColor = messageColor;
    self.messageLabel.textColor = messageColor;
}

- (void)setButtonFont:(UIFont *)buttonFont
{
    if (_buttonFont == buttonFont) return;
    
    _buttonFont = buttonFont;
    for (UIButton *button in self.buttons) {
        button.titleLabel.font = buttonFont;
    }
}

- (void)setDefaultButtonTitleColor:(UIColor *)defaultButtonTitleColor
{
    if (_defaultButtonTitleColor == defaultButtonTitleColor) return;
    
    _defaultButtonTitleColor = defaultButtonTitleColor;
    [self setTitleColor:defaultButtonTitleColor toButtonsOfType:XTAlertViewButtonTypeDefault];
}

- (void)setCancelButtonTitleColor:(UIColor *)cancelButtonTitleColor
{
    if (_cancelButtonTitleColor == cancelButtonTitleColor) return;
    
    _cancelButtonTitleColor = cancelButtonTitleColor;
    [self setTitleColor:cancelButtonTitleColor toButtonsOfType:XTAlertViewButtonTypeCancel];
}

- (void)setDefaultButtonImage:(UIImage *)defaultButtonImage forState:(UIControlState)state
{
    [self setBackgroundImage:defaultButtonImage forState:state toButtonsOfType:XTAlertViewButtonTypeDefault];
}

- (void)setCancelButtonImage:(UIImage *)cancelButtonImage forState:(UIControlState)state
{
    [self setBackgroundImage:cancelButtonImage forState:state toButtonsOfType:XTAlertViewButtonTypeCancel];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage forState:(UIControlState)state toButtonsOfType:(XTAlertViewButtonType)type
{
    if (state == UIControlStateSelected) {
        state = UIControlStateHighlighted;
    }

    for (NSUInteger i = 0; i < self.items.count; i++) {
        XTAlertItem *item = self.items[i];
        if (item.type == type) {
            UIButton *button = self.buttons[i];
            [button setBackgroundImage:backgroundImage forState:state];
        }
    }
}

- (void)setTitleColor:(UIColor *)color toButtonsOfType:(XTAlertViewButtonType)type
{
    for (NSUInteger i = 0; i < self.items.count; i++) {
        XTAlertItem *item = self.items[i];
        if (item.type == type) {
            UIButton *button = self.buttons[i];
            [button setTitleColor:color forState:UIControlStateNormal];
        }
    }
}

#pragma mark - 类方法
+ (instancetype)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles handler:(void (^)(XTAlertView *alertView, NSInteger buttonIndex))block
{
    XTAlertView *alertView = [[XTAlertView alloc] initWithTitle:title message:message];
    
    if (!XTStringIsEmpty(cancelButtonTitle)) {
        [alertView addButtonWithTitle:cancelButtonTitle type:XTAlertViewButtonTypeCancel handler:^(XTAlertView *alertView) {
            if (block) {
                block(alertView, 0);
            }
        }];
    }
    
    for (NSUInteger i = 0; i < otherButtonTitles.count; i++) {
        [alertView addButtonWithTitle:otherButtonTitles[i] type:XTAlertViewButtonTypeDefault handler:^(XTAlertView *alertView) {
            if (block) {
                if (!XTStringIsEmpty(cancelButtonTitle)) {
                    block(alertView, i + 1);
                } else {
                    block(alertView, i);
                }
            }
        }];
    }
    
    [alertView show];
    
    return alertView;
}

@end
