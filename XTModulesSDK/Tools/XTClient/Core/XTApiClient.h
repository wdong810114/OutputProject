//
//  XTApiClient.h
//  XTModulesSDK
//
//  Created by wdd on 2019/7/23.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#import "XTClientConfiguration.h"
#import "XTResponseDeserializer.h"
#import "XTSanitizer.h"

/**
 *  响应对象错误键
 */
extern NSString * const XTResponseObjectErrorKey;

/**
 *  业务数据错误域
 */
extern NSString * const XTBusinessDataErrorDomain;

@interface XTApiClient : AFHTTPSessionManager

@property (nonatomic, strong, readonly) id<XTClientConfiguration> configuration;

@property (nonatomic, assign) NSTimeInterval timeoutInterval;

@property (nonatomic, strong) id<XTResponseDeserializer> responseDeserializer;

@property (nonatomic, strong) id<XTSanitizer> sanitizer;

@property (nonatomic, strong) NSDictionary<NSString *, AFHTTPRequestSerializer <AFURLRequestSerialization> *> *requestSerializerForContentType;

+ (instancetype)sharedClient;

- (instancetype)initWithBaseURL:(NSURL *)url;
- (instancetype)initWithConfiguration:(id<XTClientConfiguration>)configuration;
- (instancetype)initWithBaseURL:(NSURL *)url configuration:(id<XTClientConfiguration>)configuration;

- (NSDictionary *)bodyWithBodyParams:(NSDictionary *)bodyParams sortKeys:(NSArray *)sortKeys;

- (NSURLSessionTask *)requestWithPath:(NSString *)path
                               method:(NSString *)method
                           pathParams:(NSDictionary *)pathParams
                          queryParams:(NSDictionary *)queryParams
                         headerParams:(NSDictionary *)headerParams
                                 body:(id)body
                   requestContentType:(NSString *)requestContentType
                  responseContentType:(NSString *)responseContentType
                         responseType:(NSString *)responseType
                      completionBlock:(void (^)(id, NSError *))completionBlock;

@end
