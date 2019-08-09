//
//  XTRefuelApi.h
//  XTModulesSDK
//
//  Created by wdd on 2019/8/6.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XTRefuelGoodsModel.h"
#import "XTRefuelOrderModel.h"
#import "XTRefuelTicketModel.h"

@class XTApiClient;

@interface XTRefuelApi : NSObject

@property (nonatomic, strong) XTApiClient *apiClient;

+ (instancetype)sharedAPI;
- (instancetype)initWithApiClient:(XTApiClient *)apiClient;

/**
 *  查询可购买的加油券商品
 *
 *  @return NSArray<XTRefuelGoodsModel>*
 */
- (NSURLSessionTask *)postQueryCouponWithCompletionHandler:(void (^)(NSArray<XTRefuelGoodsModel> *output, NSError *error))handler;

/**
 *  加油券下单
 *
 *  @param phone 手机号
 *  @param goodList 商品信息
 *
 *  @return XTRefuelOrderModel*
 */
- (NSURLSessionTask *)postGetCouponAccountWithPhone:(NSString *)phone
                                           goodList:(NSArray *)goodList
                                  completionHandler:(void (^)(XTRefuelOrderModel *output, NSError *error))handler;

/**
 *  查询用户的加油券商品列表
 *
 *  @param phone 手机号
 *
 *  @return NSArray<XTRefuelTicketModel>*
 */
- (NSURLSessionTask *)postQueryAccountCouponWithPhone:(NSString *)phone
                                    completionHandler:(void (^)(NSArray<XTRefuelTicketModel> *output, NSError *error))handler;

/**
 *  查询用户的加油券商品详情
 *
 *  @param oiarId 券ID
 *
 *  @return XTRefuelTicketModel*
 */
- (NSURLSessionTask *)postQueryAccountCouponOrderinfoWithOiarId:(NSString *)oiarId
                                              completionHandler:(void (^)(XTRefuelTicketModel *output, NSError *error))handler;

@end
