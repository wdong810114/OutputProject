//
//  XTAlertView.h
//  HappyPay
//
//  Created by wdd on 2018/8/7.
//  Copyright © 2018年 NewSky. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const XTAlertViewWillShowNotification;
extern NSString *const XTAlertViewDidShowNotification;
extern NSString *const XTAlertViewWillDismissNotification;
extern NSString *const XTAlertViewDidDismissNotification;

typedef NS_ENUM(NSInteger, XTAlertViewBackgroundStyle) {
    XTAlertViewBackgroundStyleSolid = 0, // 平面的
    XTAlertViewBackgroundStyleGradient   // 聚光的
};

typedef NS_ENUM(NSInteger, XTAlertViewButtonsListStyle) {
    XTAlertViewButtonsListStyleNormal = 0,
    XTAlertViewButtonsListStyleRows // 每个按钮都是一行
};

typedef NS_ENUM(NSInteger, XTAlertViewTransitionStyle) {
    XTAlertViewTransitionStyleFade = 0,        // 渐退
    XTAlertViewTransitionStyleSlideFromTop,    // 从顶部滑入滑出
    XTAlertViewTransitionStyleSlideFromBottom, // 从底部滑入滑出
    XTAlertViewTransitionStyleBounce,          // 弹窗效果
    XTAlertViewTransitionStyleDropDown         // 顶部滑入底部滑出
};

typedef NS_ENUM(NSInteger, XTAlertViewButtonType) {
    XTAlertViewButtonTypeDefault = 0, // 字体默认白色
    XTAlertViewButtonTypeCancel       // 字体默认灰色
};

@class XTAlertView;
typedef void(^XTAlertViewHandler)(XTAlertView *alertView);

@interface XTAlertView : UIView

/** 是否支持旋转 */
@property (nonatomic, assign) BOOL isSupportRotating;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) NSTextAlignment titleTextAlignment;
@property (nonatomic, assign) NSTextAlignment messageTextAlignment;

@property (nonatomic, assign) XTAlertViewBackgroundStyle backgroundStyle;   // 默认是 XTAlertViewBackgroundStyleSolid
@property (nonatomic, assign) XTAlertViewButtonsListStyle buttonsListStyle; // 默认是 XTAlertViewButtonsListStyleNormal
@property (nonatomic, assign) XTAlertViewTransitionStyle transitionStyle;   // 默认是 XTAlertViewTransitionStyleFade

@property (nonatomic, copy) XTAlertViewHandler willShowHandler;
@property (nonatomic, copy) XTAlertViewHandler didShowHandler;
@property (nonatomic, copy) XTAlertViewHandler willDismissHandler;
@property (nonatomic, copy) XTAlertViewHandler didDismissHandler;

@property (nonatomic, strong) UIColor *viewBackgroundColor     UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat cornerRadius             UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIFont *titleFont                UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *messageFont              UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *titleColor              UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *messageColor            UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIFont *buttonFont               UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *defaultButtonTitleColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *cancelButtonTitleColor  UI_APPEARANCE_SELECTOR;

/**
 *  设置默认按钮指定状态下的背景图片
 */
- (void)setDefaultButtonImage:(UIImage *)defaultButtonImage forState:(UIControlState)state  UI_APPEARANCE_SELECTOR;

/**
 *  设置取消按钮指定状态下的背景图片
 */
- (void)setCancelButtonImage:(UIImage *)cancelButtonImage forState:(UIControlState)state    UI_APPEARANCE_SELECTOR;

/**
 *  初始化一个弹窗提示
 */
+ (instancetype)alertViewWithTitle:(NSString *)title message:(NSString *)message;
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;

/**
 *  添加按钮点击时候和处理
 *
 *  @param title   按钮名字
 *  @param type    按钮类型
 *  @param handler 点击按钮处理事件
 */
- (void)addButtonWithTitle:(NSString *)title type:(XTAlertViewButtonType)type handler:(XTAlertViewHandler)handler;

/**
 *  显示弹窗提示
 */
- (void)show;

/**
 *  移除视图
 */
- (void)removeAlertView;

/**
 *  快速弹窗
 *
 *  @param title             标题
 *  @param message           消息体
 *  @param cancelButtonTitle 取消按钮文字
 *  @param otherButtonTitles 其他按钮文字数组
 *  @param block             回调
 *
 *  @return 返回XTAlertView对象
 */
+ (instancetype)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles handler:(void (^)(XTAlertView *alertView, NSInteger buttonIndex))block;

@end
