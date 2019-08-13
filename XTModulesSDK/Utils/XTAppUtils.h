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
