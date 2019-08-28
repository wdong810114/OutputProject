//
//  XTLifePaymentErrorAlertView.h
//  XTModulesSDK
//
//  Created by wdd on 2019/8/28.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XTLifePaymentErrorAlertView;

@protocol XTLifePaymentErrorAlertViewDelegate <NSObject>

@required
- (void)lifePaymentErrorAlertViewDidClickKnow:(XTLifePaymentErrorAlertView *)lifePaymentErrorAlertView;

@end

@interface XTLifePaymentErrorAlertView : UIView

@property (nonatomic, weak) id<XTLifePaymentErrorAlertViewDelegate> delegate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) UIImage *iconImage;

- (void)show;

@end
