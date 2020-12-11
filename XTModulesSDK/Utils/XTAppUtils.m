//
//  XTAppUtils.m
//  XTModulesSDK
//
//  Created by wdd on 2019/7/22.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTAppUtils.h"

#import "XTMacro.h"

@implementation XTAppUtils

@end

@implementation XTAppUtils (Check)

+ (BOOL)isMobile:(NSString *)string
{
    NSString *matchFormat = @"^1[3-9][0-9]\\d{8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", matchFormat];
    
    return [predicate evaluateWithObject:string];
}

@end

@implementation XTAppUtils (Image)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0, 0.0, 1.0, 1.0);
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRestoreGState(context);
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)gradientImageWithBounds:(CGRect)bounds colors:(NSArray *)colors
{
    NSMutableArray *refColors = [NSMutableArray array];
    for (UIColor *color in colors) {
        [refColors addObject:(__bridge id)color.CGColor];
    }
    
    UIGraphicsBeginImageContextWithOptions(bounds.size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)refColors, NULL);
    CGPoint start = CGPointMake(0.0, 0.0);
    CGPoint end = CGPointMake(bounds.size.width, 0.0);
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    CGContextRestoreGState(context);
    UIGraphicsEndImageContext();
    
    return image;
}

@end

@implementation XTAppUtils (String)

+ (CGSize)sizeOfString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)size
{
    return [XTAppUtils sizeOfString:string
                               font:font
                  constrainedToSize:size
                      lineBreakMode:NSLineBreakByTruncatingTail];
}

+ (CGSize)sizeOfString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    NSDictionary *attributes = @{NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle.copy};
    CGSize boundingSize = [string boundingRectWithSize:size
                                               options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                            attributes:attributes
                                               context:nil].size;
    
    return CGSizeMake(ceil(boundingSize.width), ceil(boundingSize.height));
}

@end

@implementation XTAppUtils (Date)

+ (NSString *)formatYMDWithTimestamp:(long long)timestamp
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    
    return [NSString stringWithFormat:@"%04i-%02i-%02i", (int)components.year, (int)components.month, (int)components.day];
}

+ (NSString *)formatYMDHMWithTimestamp:(long long)timestamp
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    
    return [NSString stringWithFormat:@"%04i-%02i-%02i %02i:%02i", (int)components.year, (int)components.month, (int)components.day, (int)components.hour, (int)components.minute];
}

@end

@implementation XTAppUtils (UIFactory)

+ (UIButton *)redButtonWithFrame:(CGRect)frame
{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.backgroundColor = [UIColor clearColor];
    
    [button setBackgroundImage:[XTAppUtils imageWithColor:XTBrandRedColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[XTAppUtils imageWithColor:[XTBrandRedColor colorWithAlphaComponent:0.8]] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[XTAppUtils imageWithColor:[XTBrandRedColor colorWithAlphaComponent:0.4]] forState:UIControlStateDisabled];
    
    button.titleLabel.font = XTFont(16.0);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    return button;
}

@end

@implementation XTAppUtils (UIHelper)

static NSInteger is58InchScreen = -1;
+ (BOOL)is58InchScreen
{
    if (is58InchScreen < 0) {
        is58InchScreen = (XTMainScreenWidth == 375 && XTMainScreenHeight == 812) ? 1 : 0;
    }
    return is58InchScreen > 0;
}

static NSInteger isNotchedScreen = -1;
+ (BOOL)isNotchedScreen
{
    if (@available(iOS 11, *)) {
        if (isNotchedScreen < 0) {
            if (@available(iOS 12.0, *)) {
                SEL peripheryInsetsSelector = NSSelectorFromString([NSString stringWithFormat:@"_%@%@", @"periphery", @"Insets"]);
                UIEdgeInsets peripheryInsets = UIEdgeInsetsZero;
                [[UIScreen mainScreen] xtui_performSelector:peripheryInsetsSelector withPrimitiveReturnValue:&peripheryInsets];
                if (peripheryInsets.bottom <= 0) {
                    UIWindow *window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
                    peripheryInsets = window.safeAreaInsets;
                    if (peripheryInsets.bottom <= 0) {
                        UIViewController *viewController = [UIViewController new];
                        window.rootViewController = viewController;
                        if (CGRectGetMinY(viewController.view.frame) > 20) {
                            peripheryInsets.bottom = 1;
                        }
                    }
                }
                isNotchedScreen = peripheryInsets.bottom > 0 ? 1 : 0;
            } else {
                isNotchedScreen = [XTAppUtils is58InchScreen] ? 1 : 0;
            }
        }
    } else {
        isNotchedScreen = 0;
    }
    
    return isNotchedScreen > 0;
}

+ (CGFloat)safeAreaBottomInsetForDeviceWithNotch
{
    if (@available(iOS 11, *)) {
        return [UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom;
    }
    
    return 0.0;
}

@end

@implementation NSObject (XTUI)

- (void)xtui_performSelector:(SEL)selector withPrimitiveReturnValue:(void *)returnValue
{
    [self xtui_performSelector:selector withPrimitiveReturnValue:returnValue arguments:nil];
}

- (void)xtui_performSelector:(SEL)selector withPrimitiveReturnValue:(void *)returnValue arguments:(void *)firstArgument, ...
{
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
    [invocation setTarget:self];
    [invocation setSelector:selector];
    
    if (firstArgument) {
        va_list valist;
        va_start(valist, firstArgument);
        [invocation setArgument:firstArgument atIndex:2];// 0->self, 1->_cmd
        
        void *currentArgument;
        NSInteger index = 3;
        while ((currentArgument = va_arg(valist, void *))) {
            [invocation setArgument:currentArgument atIndex:index];
            index++;
        }
        va_end(valist);
    }
    
    [invocation invoke];
    
    if (returnValue) {
        [invocation getReturnValue:returnValue];
    }
}

@end
