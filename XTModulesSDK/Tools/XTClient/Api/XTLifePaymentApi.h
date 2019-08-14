//
//  XTLifePaymentApi.h
//  XTModulesSDK
//
//  Created by wdd on 2019/8/13.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XTLifePaymentAccountModel.h"
#import "XTLifePaymentTagModel.h"
#import "XTLifePaymentPayBillModel.h"
#import "XTLifePaymentOrderModel.h"
#import "XTLifePaymentCompanyModel.h"
#import "XTLifePaymentCityModel.h"

@class XTApiClient;

@interface XTLifePaymentApi : NSObject

@property (nonatomic, strong) XTApiClient *apiClient;

+ (instancetype)sharedAPI;
- (instancetype)initWithApiClient:(XTApiClient *)apiClient;

/**
 *  查询缴费账户
 *
 *  @param phone 手机号
 *  @param accountType 账户类型，1：水费 2：电费 3：燃气费
 *
 *  @return NSArray<XTLifePaymentAccountModel>*
 */
- (NSURLSessionTask *)postQueryAccountsWithPhone:(NSString *)phone
                                     accountType:(NSString *)accountType
                               completionHandler:(void (^)(NSArray<XTLifePaymentAccountModel> *output, NSError *error))handler;

/**
 *  新增缴费账户
 *
 *  @param accountNo 账户号
 *  @param tagName 标签名称
 *  @param accountType 账户类型，1：水费 2：电费 3：燃气费
 *  @param cityCode 城市编码
 *  @param companyCode 缴费公司编码
 *  @param phone 手机号
 *
 *  @return XTModuleObject*
 */
- (NSURLSessionTask *)postAddAccountWithAccountNo:(NSString *)accountNo
                                          tagName:(NSString *)tagName
                                      accountType:(NSString *)accountType
                                         cityCode:(NSString *)cityCode
                                      companyCode:(NSString *)companyCode
                                            phone:(NSString *)phone
                                completionHandler:(void (^)(XTModuleObject *output, NSError *error))handler;

/**
 *  修改缴费账户
 *
 *  @param uuid 唯一标识
 *  @param tagName 标签名称
 *  @param accountAddress 账户地址
 *  @param accountNo 账户号
 *  @param accountType 账户类型，1：水费 2：电费 3：燃气费
 *  @param cityCode 城市编码
 *  @param companyCode 缴费公司编码
 *  @param phone 手机号
 *
 *  @return XTModuleObject*
 */
- (NSURLSessionTask *)postEditAccountWithUUID:(NSString *)uuid
                                      tagName:(NSString *)tagName
                               accountAddress:(NSString *)accountAddress
                                    accountNo:(NSString *)accountNo
                                  accountType:(NSString *)accountType
                                     cityCode:(NSString *)cityCode
                                  companyCode:(NSString *)companyCode
                                        phone:(NSString *)phone
                            completionHandler:(void (^)(XTModuleObject *output, NSError *error))handler;

/**
 *  删除缴费账户
 *
 *  @param uuid 唯一标识
 *
 *  @return XTModuleObject*
 */
- (NSURLSessionTask *)postDeleteAccountWithUUID:(NSString *)uuid
                              completionHandler:(void (^)(XTModuleObject *output, NSError *error))handler;

/**
 *  查询标签
 *
 *  @return NSArray<XTLifePaymentTagModel>*
 */
- (NSURLSessionTask *)postGetTagsWithCompletionHandler:(void (^)(NSArray<XTLifePaymentTagModel> *output, NSError *error))handler;

/**
 *  查询缴费账户信息
 *
 *  @param accountNo 账户号
 *  @param companyCode 缴费公司编码
 *  @param cityCode 城市编码
 *  @param accountType 账户类型，1：水费 2：电费 3：燃气费
 *
 *  @return XTLifePaymentPayBillModel*
 */
- (NSURLSessionTask *)postQueryAccountInfoWithAccountNo:(NSString *)accountNo
                                            companyCode:(NSString *)companyCode
                                               cityCode:(NSString *)cityCode
                                            accountType:(NSString *)accountType
                                      completionHandler:(void (^)(XTLifePaymentPayBillModel *output, NSError *error))handler;

/**
 *  生活缴费下单
 *
 *  @param accountNo 账户号
 *  @param phone 手机号
 *  @param companyCode 缴费公司编码
 *  @param cityCode 城市编码
 *  @param accountType 账户类型，1：水费 2：电费 3：燃气费
 *  @param accountAddress 账户地址
 *  @param amount 缴费金额
 *
 *  @return XTLifePaymentOrderModel*
 */
- (NSURLSessionTask *)postGetLifePaymentOrderWithAccountNo:(NSString *)accountNo
                                                     phone:(NSString *)phone
                                               companyCode:(NSString *)companyCode
                                                  cityCode:(NSString *)cityCode
                                               accountType:(NSString *)accountType
                                            accountAddress:(NSString *)accountAddress
                                                    amount:(NSString *)amount
                                         completionHandler:(void (^)(XTLifePaymentOrderModel *output, NSError *error))handler;

/**
 *  查询缴费公司
 *
 *  @param cityCode 城市编码
 *
 *  @return NSArray<XTLifePaymentCompanyModel>*
 */
- (NSURLSessionTask *)postGetCompaniesWithCityCode:(NSString *)cityCode
                                 completionHandler:(void (^)(NSArray<XTLifePaymentCompanyModel> *output, NSError *error))handler;

/**
 *  查询缴费开通城市
 *
 *  @param companyType 缴费公司类型，1：水费 2：电费 3：煤气费
 *
 *  @return NSArray<XTLifePaymentCityModel>*
 */
- (NSURLSessionTask *)postGetCitiesWithCompanyType:(NSString *)companyType
                                 completionHandler:(void (^)(NSArray<XTLifePaymentCityModel> *output, NSError *error))handler;

@end
