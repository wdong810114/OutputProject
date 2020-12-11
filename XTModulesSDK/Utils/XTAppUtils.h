//
//  XTAppUtils.h
//  XTModulesSDK
//
//  Created by wdd on 2019/7/22.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@interface XTAppUtils : NSObject

@end

@interface XTAppUtils (Check)

/**
 *  判断字符串是否是手机号
 *
 *  @param string 字符串
 *
 *  @return 判断结果
 */
+ (BOOL)isMobile:(NSString *)string;

@end

@interface XTAppUtils (Image)

/**
 *  获取单色的UIImage对象
 *
 *  @param color 颜色
 *
 *  @return 单色图像
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  获取渐变色的UIImage对象
 *
 *  @param bounds 界限
 *  @param colors 颜色数组
 *
 *  @return 渐变色图像
 */
+ (UIImage *)gradientImageWithBounds:(CGRect)bounds colors:(NSArray *)colors;

@end

@interface XTAppUtils (String)

/**
 *  得到字符串最适合大小
 *
 *  @param string 字符串
 *  @param font   字体
 *  @param size   约束大小
 *
 *  @return 最适合大小
 */
+ (CGSize)sizeOfString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)size;

/**
 *  得到字符串最适合大小
 *
 *  @param string        字符串
 *  @param font          字体
 *  @param size          约束大小
 *  @param lineBreakMode 换行模式
 *
 *  @return 最适合大小
 */
+ (CGSize)sizeOfString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end

@interface XTAppUtils (Date)

/**
 *  格式化时间戳
 *
 *  @param timestamp 时间戳
 *
 *  @return 格式化后的字符串，yyyy-MM-dd
 */
+ (NSString *)formatYMDWithTimestamp:(long long)timestamp;

/**
 *  格式化时间戳
 *
 *  @param timestamp 时间戳
 *
 *  @return 格式化后的字符串，yyyy-MM-dd HH:mm
 */
+ (NSString *)formatYMDHMWithTimestamp:(long long)timestamp;

@end

@interface XTAppUtils (UIFactory)

/**
 *  生成无圆角的红色按钮
 *
 *  @param frame 框架
 *
 *  @return 无圆角的红色按钮
 */
+ (UIButton *)redButtonWithFrame:(CGRect)frame;

@end

@interface XTAppUtils (UIHelper)

/**
 *  iPhone X / XS / 11Pro
 */
+ (BOOL)is58InchScreen;

/**
 *  是否是全面屏
 */
+ (BOOL)isNotchedScreen;

/**
 *  全面屏设备底部安全区域的高度
 */
+ (CGFloat)safeAreaBottomInsetForDeviceWithNotch;

@end

@interface NSObject (XTUI)

/**
 *  调用一个无参数、返回值类型为非对象的 selector。如果返回值类型为对象，请直接使用系统的 performSelector: 方法。
 *  @param selector 要被调用的方法名
 *  @param returnValue selector 的返回值的指针地址，请先定义一个变量再将其指针地址传进来，例如 &result
 *
 *  @code
 *  CGFloat alpha;
 *  [view xtui_performSelector:@selector(alpha) withPrimitiveReturnValue:&alpha];
 *  @endcode
 */
- (void)xtui_performSelector:(SEL)selector withPrimitiveReturnValue:(nullable void *)returnValue;

/**
 *  调用一个返回值类型为非对象且带参数的 selector，参数类型支持对象和非对象，也没有数量限制。
 *
 *  @param selector 要被调用的方法名
 *  @param returnValue selector 的返回值的指针地址
 *  @param firstArgument 参数列表，请传参数的指针地址，支持多个参数
 *
 *  @code
 *  CGPoint point = xxx;
 *  UIEvent *event = xxx;
 *  BOOL isInside;
 *  [view xtui_performSelector:@selector(pointInside:withEvent:) withPrimitiveReturnValue:&isInside arguments:&point, &event, nil];
 *  @endcode
 */
- (void)xtui_performSelector:(SEL)selector withPrimitiveReturnValue:(nullable void *)returnValue arguments:(nullable void *)firstArgument, ...;

@end
