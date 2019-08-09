//
//  XTPhoneRechargeHistoryView.h
//  XTModulesSDK
//
//  Created by wdd on 2019/7/30.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XTPhoneRechargeHistoryView;

@protocol XTPhoneRechargeHistoryViewDelegate <NSObject>

@required
- (void)phoneRechargeHistoryView:(XTPhoneRechargeHistoryView *)phoneRechargeHistoryView didSelectPhoneNumber:(NSString *)phoneNumber name:(NSString *)name;
- (void)phoneRechargeHistoryViewDidSelectCancel:(XTPhoneRechargeHistoryView *)phoneRechargeHistoryView;

@end

@interface XTPhoneRechargeHistoryView : UIView

@property (nonatomic, weak) id<XTPhoneRechargeHistoryViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)show;
- (void)hide;

+ (void)addHistoryWithPhoneNumber:(NSString *)phoneNumber name:(NSString *)name detail:(NSString *)detail;

@end
