//
//  XTPhoneRechargeApi.m
//  XTModulesSDK
//
//  Created by wdd on 2019/7/24.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTPhoneRechargeApi.h"

#import "XTApiClient.h"

@implementation XTPhoneRechargeApi

+ (instancetype)sharedAPI
{
    static XTPhoneRechargeApi *sharedApi;
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

- (NSURLSessionTask *)postQueryPhoneGoodsWithPhone:(NSString *)phone
                                 completionHandler:(void (^)(XTPhoneModel *output, NSError *error))handler
{
    NSMutableString *resourcePath = [NSMutableString stringWithFormat:@"/queryPhoneGoods"];
    
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
    id body = [self.apiClient bodyWithBodyParams:bodyParams sortKeys:sortKeys];
    
    return [self.apiClient requestWithPath:resourcePath
                                    method:@"POST"
                                pathParams:pathParams
                               queryParams:queryParams
                              headerParams:headerParams
                                      body:body
                        requestContentType:requestContentType
                       responseContentType:responseContentType
                              responseType:@"XTPhoneModel*"
                           completionBlock:^(id data, NSError *error) {
                               if (handler) {
                                   handler((XTPhoneModel *)data, error);
                               }
                           }];
}

- (NSURLSessionTask *)postGetPhoneOrderWithGoodId:(NSString *)goodId
                                       realAmount:(NSString *)realAmount
                                   rechargeAmount:(NSString *)rechargeAmount
                                         payPhone:(NSString *)payPhone
                                    rechargePhone:(NSString *)rechargePhone
                                completionHandler:(void (^)(XTPhoneRechargeOrderModel *output, NSError *error))handler
{
    NSMutableString *resourcePath = [NSMutableString stringWithFormat:@"/getPhoneOrder"];
    
    NSMutableDictionary *pathParams = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *queryParams = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *headerParams = [NSMutableDictionary dictionaryWithDictionary:self.apiClient.configuration.defaultHeaders];
    
    NSString *acceptHeader = [self.apiClient.sanitizer selectHeaderAccepts:@[@"application/json"]];
    NSString *responseContentType = [[acceptHeader componentsSeparatedByString:@", "] firstObject] ? : @"";
    
    NSString *requestContentType = [self.apiClient.sanitizer selectHeaderContentTypes:@[@"application/json"]];
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] init];
    NSMutableArray *sortKeys = [[NSMutableArray alloc] init];
    if (goodId && goodId.length > 0) {
        bodyParams[@"goodId"] = goodId;
        [sortKeys addObject:@"goodId"];
    }
    if (realAmount && realAmount.length > 0) {
        bodyParams[@"realAmount"] = realAmount;
        [sortKeys addObject:@"realAmount"];
    }
    if (rechargeAmount && rechargeAmount.length > 0) {
        bodyParams[@"rechargeAmount"] = rechargeAmount;
        [sortKeys addObject:@"rechargeAmount"];
    }
    if (payPhone && payPhone.length > 0) {
        bodyParams[@"payPhone"] = payPhone;
        [sortKeys addObject:@"payPhone"];
    }
    if (rechargePhone && rechargePhone.length > 0) {
        bodyParams[@"rechargePhone"] = rechargePhone;
        [sortKeys addObject:@"rechargePhone"];
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
                              responseType:@"XTPhoneRechargeOrderModel*"
                           completionBlock:^(id data, NSError *error) {
                               if (handler) {
                                   handler((XTPhoneRechargeOrderModel *)data, error);
                               }
                           }];
}

@end
