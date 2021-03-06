//
//  XTMacro.h
//  XTModulesSDK
//
//  Created by wdd on 2019/7/22.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTAppUtils.h"

#define XTIsModulesOutput 1 // 是否模块外放

/******* 屏幕尺寸 *******/
#define XTMainScreenBounds  [UIScreen mainScreen].bounds // 屏幕界限
#define XTMainScreenSize    XTMainScreenBounds.size      // 屏幕大小
#define XTMainScreenWidth   XTMainScreenSize.width       // 屏幕宽度
#define XTMainScreenHeight  XTMainScreenSize.height      // 屏幕高度

// 是否全面屏设备
#define XTIsNotchedScreen [XTAppUtils isNotchedScreen]
// 状态栏高度
#define XTStatusBarHeight (UIApplication.sharedApplication.statusBarHidden ? 0 : UIApplication.sharedApplication.statusBarFrame.size.height)
// 导航栏高度
#define XTNavigationBarHeight 44.0
// 代表(状态栏+导航栏)，这里用于获取其高度
#define XTNavigationContentTop (XTStatusBarHeight + XTNavigationBarHeight)
// 全面屏手机底部安全区域的高度
#define XTSafeAreaBottomInsetForDeviceWithNotch [XTAppUtils safeAreaBottomInsetForDeviceWithNotch]
// 非顶层视图高度
#define XTNonTopLevelViewHeight (XTMainScreenHeight - XTNavigationContentTop - XTSafeAreaBottomInsetForDeviceWithNotch)
/******* 屏幕尺寸 *******/

/******* 屏幕系数 *******/
#define XTiPhone6WidthCoefficient(width)  ((width) / 375.0)    // 以苹果6为准的系数
#define XTiPhone6HeightCoefficient(height)  ((height) / 667.0) // 以苹果6为准的系数
#define XTiPhone6ScaleWidth(width)  (XTiPhone6WidthCoefficient(width) * XTMainScreenWidth) // 以苹果6为准的系数得到的宽
#define XTiPhone6ScaleHeight(height)  (XTiPhone6HeightCoefficient(height) * XTMainScreenHeight) // 以苹果6为准的系数得到的高
/******* 屏幕系数 *******/

/******* 字体 *******/
#define XTFont(S)      [UIFont systemFontOfSize:S]
#define XTBoldFont(S)  [UIFont boldSystemFontOfSize:S]
/******* 字体 *******/

/******* RGB颜色 *******/
#define XTColorAlpha(r, g, b, a)  [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:a]
#define XTColor(r, g, b)  XTColorAlpha(r, g, b, 1.0)

#define XTColorFromHexAlpha(rgbValue, a)  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:a]
#define XTColorFromHex(rgbValue)  XTColorFromHexAlpha(rgbValue, 1.0)

#define XTBrandBlackColor       XTColorFromHex(0x333333) // 品牌黑
#define XTBrandLightBlackColor  XTColorFromHex(0x505050) // 品牌浅黑
#define XTBrandGrayColor        XTColorFromHex(0x767676) // 品牌灰
#define XTBrandLightGrayColor   XTColorFromHex(0xABABAB) // 品牌浅灰
#define XTBrandRedColor         XTColorFromHex(0xE0282A) // 品牌红

#define XTViewBGColor     XTColorFromHex(0xF6F6F6) // 视图背景颜色
#define XTSeparatorColor  XTColorFromHex(0xE8E8E8) // 分割线颜色
/******* RGB颜色 *******/

/******* 效验对象是否是空 *******/
#define XTStringIsEmpty(str)  (str == nil || [str isKindOfClass:[NSNull class]] || [str length] < 1 ? YES : NO)
#define XTArrayIsEmpty(array)  (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
#define XTDictionaryIsEmpty(dict)  (dict == nil || [dict isKindOfClass:[NSNull class]] || dict.allKeys == 0)
#define XTObjectIsEmpty(_object)  (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))
/******* 效验对象是否是空 *******/

/******* 其它 *******/
#if XTIsModulesOutput
    #define XTModulesSDKBundle  [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"XTModulesSDKBundle" withExtension:@"bundle"]]
    #define XTModulesSDKNib(name)  [UINib nibWithNibName:name bundle:XTModulesSDKBundle]
    #define XTModulesSDKImage(name)  [[[NSBundle mainBundle] pathForResource:@"XTModulesSDKBundle" ofType:@"bundle"] stringByAppendingPathComponent:name]
#else
    #define XTModulesSDKResource(name) [@"Frameworks/XTModulesSDK.framework" stringByAppendingPathComponent:name]
    #define XTModulesSDKNib(name)  [UINib nibWithNibName:XTModulesSDKResource(name) bundle:nil]
    #define XTModulesSDKImage(name)  [XTModulesSDKResource(@"XTModulesSDK.bundle") stringByAppendingPathComponent:name]
#endif

#define XTMainWindow  [UIApplication sharedApplication].windows.firstObject
#define XTNotificationCenter  [NSNotificationCenter defaultCenter]
#define XTWeakSelf(weakSelf)  __weak typeof(*&self)weakSelf = self
#define XTIndexPath(row, section)  [NSIndexPath indexPathForRow:row inSection:section]
#define XTDispatchAsyncOnMainQueue(x)  __weak typeof(self) weakSelf = self; \
                                       dispatch_async(dispatch_get_main_queue(), ^{ \
                                           typeof(weakSelf) self = weakSelf; \
                                           {x} \
                                       });
#define XTDeviceSystemVersion  [UIDevice currentDevice].systemVersion.floatValue

#define XTIsReachable [[XTModulesManager sharedManager] isReachable]
#define XTNetworkUnavailable   @"网络加载失败，请稍后再试"
#define XTUserTokenInvalidErrorCode  21014

#define XTPhoneNumberLength    11             // 手机号长度
#define XTDigitalCharacterSet  @"0123456789"  // 数字集合
#define XTDecimalCharacterSet  @"0123456789." // 小数集合

#define XTPageCapacity  10
/******* 其它 *******/
