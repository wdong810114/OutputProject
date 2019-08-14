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
 *  @param oilStatus 加油券状态，0：未使用 2：已过期 3：已使用 4：未激活
 *  @param currentPage 当前页
 *  @param pageSize 每页显示个数
 *
 *  @return NSArray<XTRefuelTicketModel>*
 */
- (NSURLSessionTask *)postQueryAccountCouponWithPhone:(NSString *)phone
                                            oilStatus:(NSString *)oilStatus
                                          currentPage:(NSString *)currentPage
                                             pageSize:(NSString *)pageSize
                                    completionHandler:(void (^)(NSArray<XTRefuelTicketModel> *output, NSError *error))handler;

/**
 *  查询用户的加油券商品详情
 *
 *  @param ticketId 券ID
 *
 *  @return XTRefuelTicketModel*
 */
- (NSURLSessionTask *)postQueryAccountCouponOrderinfoWithTicketId:(NSString *)ticketId
                                                completionHandler:(void (^)(XTRefuelTicketModel *output, NSError *error))handler;

@end
