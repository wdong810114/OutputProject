//
//  XTPhoneRechargeApi.h
//  XTModulesSDK
//
//  Created by wdd on 2019/7/24.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XTApiClient.h"
#import "XTPhoneModel.h"
#import "XTPhoneRechargeOrderModel.h"

@interface XTPhoneRechargeApi : NSObject

@property (nonatomic, strong) XTApiClient *apiClient;

+ (instancetype)sharedAPI;
- (instancetype)initWithApiClient:(XTApiClient *)apiClient;

/**
 *  查询话费可充值金额商品
 *
 *  @param phone 手机号
 *
 *  @return XTPhoneModel*
 */
- (NSURLSessionTask *)postQueryPhoneGoodsWithPhone:(NSString *)phone
                                 completionHandler:(void (^)(XTPhoneModel *output, NSError *error))handler;

/**
 *  话费充值下单
 *
 *  @param goodId 商品代码
 *  @param realAmount 商品实际金额
 *  @param rechargeAmount 实付金额
 *  @param payPhone 付钱的手机号
 *  @param rechargePhone 被充值的手机号
 *
 *  @return XTPhoneRechargeOrderModel*
 */
- (NSURLSessionTask *)postGetPhoneOrderWithGoodId:(NSString *)goodId
                                       realAmount:(NSString *)realAmount
                                   rechargeAmount:(NSString *)rechargeAmount
                                         payPhone:(NSString *)payPhone
                                    rechargePhone:(NSString *)rechargePhone
                                completionHandler:(void (^)(XTPhoneRechargeOrderModel *output, NSError *error))handler;

@end
