//
//  XTRefuelApi.m
//  XTModulesSDK
//
//  Created by wdd on 2019/8/6.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTRefuelApi.h"

#import "XTApiClient.h"

@implementation XTRefuelApi

+ (instancetype)sharedAPI
{
    static XTRefuelApi *sharedApi;
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

- (NSURLSessionTask *)postQueryCouponWithCompletionHandler:(void (^)(NSArray<XTRefuelGoodsModel> *output, NSError *error))handler
{
    NSMutableString *resourcePath = [NSMutableString stringWithFormat:@"/queryCoupon"];
    
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
                              responseType:@"NSArray<XTRefuelGoodsModel>*"
                           completionBlock:^(id data, NSError *error) {
                               if (handler) {
                                   handler((NSArray<XTRefuelGoodsModel> *)data, error);
                               }
                           }];
}

- (NSURLSessionTask *)postGetCouponAccountWithPhone:(NSString *)phone
                                           goodList:(NSArray *)goodList
                                  completionHandler:(void (^)(XTRefuelOrderModel *output, NSError *error))handler
{
    NSMutableString *resourcePath = [NSMutableString stringWithFormat:@"/getCouponAccount"];
    
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
    if (goodList && goodList.count > 0) {
        bodyParams[@"GoodList"] = goodList;
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
                              responseType:@"XTRefuelOrderModel*"
                           completionBlock:^(id data, NSError *error) {
                               if (handler) {
                                   handler((XTRefuelOrderModel *)data, error);
                               }
                           }];
}

- (NSURLSessionTask *)postQueryAccountCouponWithPhone:(NSString *)phone
                                            oilStatus:(NSString *)oilStatus
                                          currentPage:(NSString *)currentPage
                                             pageSize:(NSString *)pageSize
                                    completionHandler:(void (^)(NSArray<XTRefuelTicketModel> *output, NSError *error))handler
{
    NSMutableString *resourcePath = [NSMutableString stringWithFormat:@"/queryAccountCoupon"];
    
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
    if (oilStatus && oilStatus.length > 0) {
        bodyParams[@"oilStatus"] = oilStatus;
        [sortKeys addObject:@"oilStatus"];
    }
    if (currentPage && currentPage.length > 0) {
        bodyParams[@"currentPage"] = currentPage;
        [sortKeys addObject:@"currentPage"];
    }
    if (pageSize && pageSize.length > 0) {
        bodyParams[@"pageSize"] = pageSize;
        [sortKeys addObject:@"pageSize"];
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
                              responseType:@"NSArray<XTRefuelTicketModel>*"
                           completionBlock:^(id data, NSError *error) {
                               if (handler) {
                                   handler((NSArray<XTRefuelTicketModel> *)data, error);
                               }
                           }];
}

- (NSURLSessionTask *)postQueryAccountCouponOrderinfoWithOiarId:(NSString *)oiarId
                                              completionHandler:(void (^)(XTRefuelTicketModel *output, NSError *error))handler
{
    NSMutableString *resourcePath = [NSMutableString stringWithFormat:@"/queryAccountCouponOrderinfo"];
    
    NSMutableDictionary *pathParams = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *queryParams = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *headerParams = [NSMutableDictionary dictionaryWithDictionary:self.apiClient.configuration.defaultHeaders];
    
    NSString *acceptHeader = [self.apiClient.sanitizer selectHeaderAccepts:@[@"application/json"]];
    NSString *responseContentType = [[acceptHeader componentsSeparatedByString:@", "] firstObject] ? : @"";
    
    NSString *requestContentType = [self.apiClient.sanitizer selectHeaderContentTypes:@[@"application/json"]];
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] init];
    NSMutableArray *sortKeys = [[NSMutableArray alloc] init];
    if (oiarId && oiarId.length > 0) {
        bodyParams[@"oiarId"] = oiarId;
        [sortKeys addObject:@"oiarId"];
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
                              responseType:@"XTRefuelTicketModel*"
                           completionBlock:^(id data, NSError *error) {
                               if (handler) {
                                   handler((XTRefuelTicketModel *)data, error);
                               }
                           }];
}

@end
