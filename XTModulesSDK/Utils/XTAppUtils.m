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
