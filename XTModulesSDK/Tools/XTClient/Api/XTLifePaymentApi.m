//
//  XTLifePaymentApi.m
//  XTModulesSDK
//
//  Created by wdd on 2019/8/13.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTLifePaymentApi.h"

#import "XTApiClient.h"

@implementation XTLifePaymentApi

+ (instancetype)sharedAPI
{
    static XTLifePaymentApi *sharedApi;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedApi = [[self alloc] init];
    });
    
    return sharedApi;
}

- (instancetype)init
{
    return [self initWithApiClient:[XTApiClient sharedClient]];
}

- (instancetype)initWithApiClient:(XTApiClient *)apiClient
{
    self = [super init];
    if (self) {
        _apiClient = apiClient;
    }
    
    return self;
}

- (NSURLSessionTask *)postQueryAccountsWithPhone:(NSString *)phone
                                     accountType:(NSString *)accountType
                               completionHandler:(void (^)(NSArray<XTLifePaymentAccountModel> *output, NSError *error))handler
{
    NSMutableString *resourcePath = [NSMutableString stringWithFormat:@"/queryAccountInfo"];
    
    NSMutableDictionary *pathParams = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *queryParams = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *headerParams = [NSMutableDictionary dictionaryWithDictionary:self.apiClient.configuration.defaultHeaders];
    
    NSString *acceptHeader = [self.apiClient.sanitizer selectHeaderAccepts:@[@"application/json"]];
    NSString *responseContentType = [[acceptHeader componentsSeparatedByString:@", "] firstObject] ? : @"";
    
    NSString *requestContentType = [self.apiClient.sanitizer selectHeaderContentTypes:@[@"application/json"]];
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] init];
    NSMutableArray *sortKeys = [[NSMutableArray alloc] init];
    if (phone && phone.length > 0) {
        bodyParams[@"phone"] = phone;
        [sortKeys addObject:@"phone"];
    }
    if (accountType && accountType.length > 0) {
        bodyParams[@"type"] = accountType;
        [sortKeys addObject:@"type"];
    }
    id body = [self.apiClient bodyWithBodyParams:bodyParams sortKeys:sortKeys];
    
    return [self.apiClient requestWithPath:resourcePath
                                    method:@"POST"
                                pathParams:pathParams
                               queryParams:queryParams
                              headerParams:headerParams
                                      body:body
                        requestContentType:requestContentType
                       responseContentType:responseContentType
                              responseType:@"NSArray<XTLifePaymentAccountModel>*"
                           completionBlock:^(id data, NSError *error) {
                               if (handler) {
                                   handler((NSArray<XTLifePaymentAccountModel> *)data, error);
                               }
                           }];
}

- (NSURLSessionTask *)postAddAccountWithAccountNo:(NSString *)accountNo
                                          tagCode:(NSString *)tagCode
                                      accountType:(NSString *)accountType
                                         cityCode:(NSString *)cityCode
                                      companyCode:(NSString *)companyCode
                                            phone:(NSString *)phone
                                completionHandler:(void (^)(XTModuleObject *output, NSError *error))handler
{
    NSMutableString *resourcePath = [NSMutableString stringWithFormat:@"/addAccount"];
    
    NSMutableDictionary *pathParams = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *queryParams = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *headerParams = [NSMutableDictionary dictionaryWithDictionary:self.apiClient.configuration.defaultHeaders];
    
    NSString *acceptHeader = [self.apiClient.sanitizer selectHeaderAccepts:@[@"application/json"]];
    NSString *responseContentType = [[acceptHeader componentsSeparatedByString:@", "] firstObject] ? : @"";
    
    NSString *requestContentType = [self.apiClient.sanitizer selectHeaderContentTypes:@[@"application/json"]];
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] init];
    NSMutableArray *sortKeys = [[NSMutableArray alloc] init];
    if (accountNo && accountNo.length > 0) {
        bodyParams[@"account"] = accountNo;
        [sortKeys addObject:@"account"];
    }
    if (tagCode && tagCode.length > 0) {
        bodyParams[@"tagCode"] = tagCode;
        [sortKeys addObject:@"tagCode"];
    }
    if (accountType && accountType.length > 0) {
        bodyParams[@"type"] = accountType;
        [sortKeys addObject:@"type"];
    }
    if (cityCode && cityCode.length > 0) {
        bodyParams[@"cityCode"] = cityCode;
        [sortKeys addObject:@"cityCode"];
    }
    if (companyCode && companyCode.length > 0) {
        bodyParams[@"companyId"] = companyCode;
        [sortKeys addObject:@"companyId"];
    }
    if (phone && phone.length > 0) {
        bodyParams[@"phone"] = phone;
        [sortKeys addObject:@"phone"];
    }
    id body = [self.apiClient bodyWithBodyParams:bodyParams sortKeys:sortKeys];
    
    return [self.apiClient requestWithPath:resourcePath
                                    method:@"POST"
                                pathParams:pathParams
                               queryParams:queryParams
                              headerParams:headerParams
                                      body:body
                        requestContentType:requestContentType
                       responseContentType:responseContentType
                              responseType:@"XTModuleObject*"
                           completionBlock:^(id data, NSError *error) {
                               if (handler) {
                                   handler((XTModuleObject *)data, error);
                               }
                           }];
}

- (NSURLSessionTask *)postEditAccountWithUUID:(NSString *)uuid
                                      tagCode:(NSString *)tagCode
                               accountAddress:(NSString *)accountAddress
                                    accountNo:(NSString *)accountNo
                                  accountType:(NSString *)accountType
                                     cityCode:(NSString *)cityCode
                                  companyCode:(NSString *)companyCode
                                        phone:(NSString *)phone
                            completionHandler:(void (^)(XTModuleObject *output, NSError *error))handler
{
    NSMutableString *resourcePath = [NSMutableString stringWithFormat:@"/editAccount"];
    
    NSMutableDictionary *pathParams = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *queryParams = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *headerParams = [NSMutableDictionary dictionaryWithDictionary:self.apiClient.configuration.defaultHeaders];
    
    NSString *acceptHeader = [self.apiClient.sanitizer selectHeaderAccepts:@[@"application/json"]];
    NSString *responseContentType = [[acceptHeader componentsSeparatedByString:@", "] firstObject] ? : @"";
    
    NSString *requestContentType = [self.apiClient.sanitizer selectHeaderContentTypes:@[@"application/json"]];
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] init];
    NSMutableArray *sortKeys = [[NSMutableArray alloc] init];
    if (uuid && uuid.length > 0) {
        bodyParams[@"uuid"] = uuid;
        [sortKeys addObject:@"uuid"];
    }
    if (tagCode && tagCode.length > 0) {
        bodyParams[@"tagCode"] = tagCode;
        [sortKeys addObject:@"tagCode"];
    }
    if (accountAddress && accountAddress.length > 0) {
        bodyParams[@"address"] = accountAddress;
        [sortKeys addObject:@"address"];
    }
    if (accountNo && accountNo.length > 0) {
        bodyParams[@"account"] = accountNo;
        [sortKeys addObject:@"account"];
    }
    if (accountType && accountType.length > 0) {
        bodyParams[@"type"] = accountType;
        [sortKeys addObject:@"type"];
    }
    if (cityCode && cityCode.length > 0) {
        bodyParams[@"cityCode"] = cityCode;
        [sortKeys addObject:@"cityCode"];
    }
    if (companyCode && companyCode.length > 0) {
        bodyParams[@"companyId"] = companyCode;
        [sortKeys addObject:@"companyId"];
    }
    if (phone && phone.length > 0) {
        bodyParams[@"phone"] = phone;
        [sortKeys addObject:@"phone"];
    }
    id body = [self.apiClient bodyWithBodyParams:bodyParams sortKeys:sortKeys];
    
    return [self.apiClient requestWithPath:resourcePath
                                    method:@"POST"
                                pathParams:pathParams
                               queryParams:queryParams
                              headerParams:headerParams
                                      body:body
                        requestContentType:requestContentType
                       responseContentType:responseContentType
                              responseType:@"XTModuleObject*"
                           completionBlock:^(id data, NSError *error) {
                               if (handler) {
                                   handler((XTModuleObject *)data, error);
                               }
                           }];
}

- (NSURLSessionTask *)postDeleteAccountWithUUID:(NSString *)uuid
                              completionHandler:(void (^)(XTModuleObject *output, NSError *error))handler
{
    NSMutableString *resourcePath = [NSMutableString stringWithFormat:@"/delAccount"];
    
    NSMutableDictionary *pathParams = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *queryParams = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *headerParams = [NSMutableDictionary dictionaryWithDictionary:self.apiClient.configuration.defaultHeaders];
    
    NSString *acceptHeader = [self.apiClient.sanitizer selectHeaderAccepts:@[@"application/json"]];
    NSString *responseContentType = [[acceptHeader componentsSeparatedByString:@", "] firstObject] ? : @"";
    
    NSString *requestContentType = [self.apiClient.sanitizer selectHeaderContentTypes:@[@"application/json"]];
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] init];
    NSMutableArray *sortKeys = [[NSMutableArray alloc] init];
    if (uuid && uuid.length > 0) {
        bodyParams[@"uuid"] = uuid;
        [sortKeys addObject:@"uuid"];
    }
    id body = [self.apiClient bodyWithBodyParams:bodyParams sortKeys:sortKeys];
    
    return [self.apiClient requestWithPath:resourcePath
                                    method:@"POST"
                                pathParams:pathParams
                               queryParams:queryParams
                              headerParams:headerParams
                                      body:body
                        requestContentType:requestContentType
                       responseContentType:responseContentType
                              responseType:@"XTModuleObject*"
                           completionBlock:^(id data, NSError *error) {
                               if (handler) {
                                   handler((XTModuleObject *)data, error);
                               }
                           }];
}

- (NSURLSessionTask *)postGetTagsWithCompletionHandler:(void (^)(NSArray<XTLifePaymentTagModel> *output, NSError *error))handler
{
    NSMutableString *resourcePath = [NSMutableString stringWithFormat:@"/getAccountFlag"];
    
    NSMutableDictionary *pathParams = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *queryParams = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *headerParams = [NSMutableDictionary dictionaryWithDictionary:self.apiClient.configuration.defaultHeaders];
    
    NSString *acceptHeader = [self.apiClient.sanitizer selectHeaderAccepts:@[@"application/json"]];
    NSString *responseContentType = [[acceptHeader componentsSeparatedByString:@", "] firstObject] ? : @"";
    
    NSString *requestContentType = [self.apiClient.sanitizer selectHeaderContentTypes:@[@"application/json"]];
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] init];
    NSMutableArray *sortKeys = [[NSMutableArray alloc] init];
    id body = [self.apiClient bodyWithBodyParams:bodyParams sortKeys:sortKeys];
    
    return [self.apiClient requestWithPath:resourcePath
                                    method:@"POST"
                                pathParams:pathParams
                               queryParams:queryParams
                              headerParams:headerParams
                                      body:body
                        requestContentType:requestContentType
                       responseContentType:responseContentType
                              responseType:@"NSArray<XTLifePaymentTagModel>*"
                           completionBlock:^(id data, NSError *error) {
                               if (handler) {
                                   handler((NSArray<XTLifePaymentTagModel> *)data, error);
                               }
                           }];
}

- (NSURLSessionTask *)postQueryAccountInfoWithAccountNo:(NSString *)accountNo
                                            companyCode:(NSString *)companyCode
                                               cityCode:(NSString *)cityCode
                                            accountType:(NSString *)accountType
                                      completionHandler:(void (^)(XTLifePaymentPayBillModel *output, NSError *error))handler
{
    NSMutableString *resourcePath = [NSMutableString stringWithFormat:@"/queryLifeAccount"];
    
    NSMutableDictionary *pathParams = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *queryParams = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *headerParams = [NSMutableDictionary dictionaryWithDictionary:self.apiClient.configuration.defaultHeaders];
    
    NSString *acceptHeader = [self.apiClient.sanitizer selectHeaderAccepts:@[@"application/json"]];
    NSString *responseContentType = [[acceptHeader componentsSeparatedByString:@", "] firstObject] ? : @"";
    
    NSString *requestContentType = [self.apiClient.sanitizer selectHeaderContentTypes:@[@"application/json"]];
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] init];
    NSMutableArray *sortKeys = [[NSMutableArray alloc] init];
    if (accountNo && accountNo.length > 0) {
        bodyParams[@"billKey"] = accountNo;
        [sortKeys addObject:@"billKey"];
    }
    if (companyCode && companyCode.length > 0) {
        bodyParams[@"companyId"] = companyCode;
        [sortKeys addObject:@"companyId"];
    }
    if (cityCode && cityCode.length > 0) {
        bodyParams[@"cityId"] = cityCode;
        [sortKeys addObject:@"cityId"];
    }
    if (accountType && accountType.length > 0) {
        bodyParams[@"payType"] = accountType;
        [sortKeys addObject:@"payType"];
    }
    id body = [self.apiClient bodyWithBodyParams:bodyParams sortKeys:sortKeys];
    
    return [self.apiClient requestWithPath:resourcePath
                                    method:@"POST"
                                pathParams:pathParams
                               queryParams:queryParams
                              headerParams:headerParams
                                      body:body
                        requestContentType:requestContentType
                       responseContentType:responseContentType
                              responseType:@"XTLifePaymentPayBillModel*"
                           completionBlock:^(id data, NSError *error) {
                               if (handler) {
                                   handler((XTLifePaymentPayBillModel *)data, error);
                               }
                           }];
}

- (NSURLSessionTask *)postGetLifePaymentOrderWithAccountNo:(NSString *)accountNo
                                                     phone:(NSString *)phone
                                               companyCode:(NSString *)companyCode
                                                  cityCode:(NSString *)cityCode
                                               accountType:(NSString *)accountType
                                            accountAddress:(NSString *)accountAddress
                                                    amount:(NSString *)amount
                                         completionHandler:(void (^)(XTLifePaymentOrderModel *output, NSError *error))handler
{
    NSMutableString *resourcePath = [NSMutableString stringWithFormat:@"/getLifeAccount"];
    
    NSMutableDictionary *pathParams = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *queryParams = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *headerParams = [NSMutableDictionary dictionaryWithDictionary:self.apiClient.configuration.defaultHeaders];
    
    NSString *acceptHeader = [self.apiClient.sanitizer selectHeaderAccepts:@[@"application/json"]];
    NSString *responseContentType = [[acceptHeader componentsSeparatedByString:@", "] firstObject] ? : @"";
    
    NSString *requestContentType = [self.apiClient.sanitizer selectHeaderContentTypes:@[@"application/json"]];
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] init];
    NSMutableArray *sortKeys = [[NSMutableArray alloc] init];
    if (accountNo && accountNo.length > 0) {
        bodyParams[@"billKey"] = accountNo;
        [sortKeys addObject:@"billKey"];
    }
    if (phone && phone.length > 0) {
        bodyParams[@"phone"] = phone;
        [sortKeys addObject:@"phone"];
    }
    if (companyCode && companyCode.length > 0) {
        bodyParams[@"companyId"] = companyCode;
        [sortKeys addObject:@"companyId"];
    }
    if (cityCode && cityCode.length > 0) {
        bodyParams[@"cityId"] = cityCode;
        [sortKeys addObject:@"cityId"];
    }
    if (accountType && accountType.length > 0) {
        bodyParams[@"payType"] = accountType;
        [sortKeys addObject:@"payType"];
    }
    if (accountAddress && accountAddress.length > 0) {
        bodyParams[@"customerName"] = accountAddress;
        [sortKeys addObject:@"customerName"];
    }
    if (amount && amount.length > 0) {
        bodyParams[@"amount"] = amount;
        [sortKeys addObject:@"amount"];
    }
    id body = [self.apiClient bodyWithBodyParams:bodyParams sortKeys:sortKeys];
    
    return [self.apiClient requestWithPath:resourcePath
                                    method:@"POST"
                                pathParams:pathParams
                               queryParams:queryParams
                              headerParams:headerParams
                                      body:body
                        requestContentType:requestContentType
                       responseContentType:responseContentType
                              responseType:@"XTLifePaymentOrderModel*"
                           completionBlock:^(id data, NSError *error) {
                               if (handler) {
                                   handler((XTLifePaymentOrderModel *)data, error);
                               }
                           }];
}

- (NSURLSessionTask *)postGetCompaniesWithCityCode:(NSString *)cityCode
                                 completionHandler:(void (^)(NSArray<XTLifePaymentCompanyModel> *output, NSError *error))handler
{
    NSMutableString *resourcePath = [NSMutableString stringWithFormat:@"/getCompany"];
    
    NSMutableDictionary *pathParams = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *queryParams = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *headerParams = [NSMutableDictionary dictionaryWithDictionary:self.apiClient.configuration.defaultHeaders];
    
    NSString *acceptHeader = [self.apiClient.sanitizer selectHeaderAccepts:@[@"application/json"]];
    NSString *responseContentType = [[acceptHeader componentsSeparatedByString:@", "] firstObject] ? : @"";
    
    NSString *requestContentType = [self.apiClient.sanitizer selectHeaderContentTypes:@[@"application/json"]];
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] init];
    NSMutableArray *sortKeys = [[NSMutableArray alloc] init];
    if (cityCode && cityCode.length > 0) {
        bodyParams[@"cityCode"] = cityCode;
        [sortKeys addObject:@"cityCode"];
    }
    id body = [self.apiClient bodyWithBodyParams:bodyParams sortKeys:sortKeys];
    
    return [self.apiClient requestWithPath:resourcePath
                                    method:@"POST"
                                pathParams:pathParams
                               queryParams:queryParams
                              headerParams:headerParams
                                      body:body
                        requestContentType:requestContentType
                       responseContentType:responseContentType
                              responseType:@"NSArray<XTLifePaymentCompanyModel>*"
                           completionBlock:^(id data, NSError *error) {
                               if (handler) {
                                   handler((NSArray<XTLifePaymentCompanyModel> *)data, error);
                               }
                           }];
}

- (NSURLSessionTask *)postGetCitiesWithCompanyType:(NSString *)companyType
                                 completionHandler:(void (^)(NSArray<XTLifePaymentCityModel> *output, NSError *error))handler
{
    NSMutableString *resourcePath = [NSMutableString stringWithFormat:@"/getCity"];
    
    NSMutableDictionary *pathParams = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *queryParams = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *headerParams = [NSMutableDictionary dictionaryWithDictionary:self.apiClient.configuration.defaultHeaders];
    
    NSString *acceptHeader = [self.apiClient.sanitizer selectHeaderAccepts:@[@"application/json"]];
    NSString *responseContentType = [[acceptHeader componentsSeparatedByString:@", "] firstObject] ? : @"";
    
    NSString *requestContentType = [self.apiClient.sanitizer selectHeaderContentTypes:@[@"application/json"]];
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] init];
    NSMutableArray *sortKeys = [[NSMutableArray alloc] init];
    if (companyType && companyType.length > 0) {
        bodyParams[@"companyType"] = companyType;
        [sortKeys addObject:@"companyType"];
    }
    id body = [self.apiClient bodyWithBodyParams:bodyParams sortKeys:sortKeys];
    
    return [self.apiClient requestWithPath:resourcePath
                                    method:@"POST"
                                pathParams:pathParams
                               queryParams:queryParams
                              headerParams:headerParams
                                      body:body
                        requestContentType:requestContentType
                       responseContentType:responseContentType
                              responseType:@"NSArray<XTLifePaymentCityModel>*"
                           completionBlock:^(id data, NSError *error) {
                               if (handler) {
                                   handler((NSArray<XTLifePaymentCityModel> *)data, error);
                               }
                           }];
}

@end
