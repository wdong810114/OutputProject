//
//  XTApiClient.m
//  XTModulesSDK
//
//  Created by wdd on 2019/7/23.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTApiClient.h"

#import <CommonCrypto/CommonDigest.h>
#import "XTDefaultClientConfiguration.h"
#import "XTJSONRequestSerializer.h"

NSString * const XTResponseObjectErrorKey = @"XTResponseObjectErrorKey";

NSString * const XTBusinessDataErrorDomain = @"XTBusinessDataErrorDomain";

@implementation XTApiClient

+ (instancetype) sharedClient
{
    static XTApiClient *apiClient = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        apiClient = [[self alloc] init];
    });
    
    return apiClient;
}

- (instancetype)init
{
    return [self initWithConfiguration:[XTDefaultClientConfiguration sharedConfig]];
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    return [self initWithBaseURL:url configuration:[XTDefaultClientConfiguration sharedConfig]];
}

- (instancetype)initWithConfiguration:(id<XTClientConfiguration>)configuration
{
    return [self initWithBaseURL:[NSURL URLWithString:configuration.host] configuration:configuration];
}

- (instancetype)initWithBaseURL:(NSURL *)url configuration:(id<XTClientConfiguration>)configuration
{
    self = [super initWithBaseURL:url];
    if (self) {
        _configuration = configuration;
        _timeoutInterval = 30;
        _responseDeserializer = [[XTResponseDeserializer alloc] init];
        _sanitizer = [[XTSanitizer alloc] init];

        XTJSONRequestSerializer *xtjsonRequestSerializer = [XTJSONRequestSerializer serializer];
        _requestSerializerForContentType = @{kXTApplicationJSONType : xtjsonRequestSerializer};
        
        self.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    return self;
}

- (NSDictionary *)bodyWithBodyParams:(NSDictionary *)bodyParams sortKeys:(NSArray *)sortKeys
{
    if (sortKeys.count == 0) {
        return nil;
    }
    
    NSMutableArray *pairs = [[NSMutableArray alloc] init];
    [sortKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, bodyParams[key]]];
    }];
    
    NSString *signString = [pairs componentsJoinedByString:@"&"];
    signString = [signString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSMutableDictionary *body = [[NSMutableDictionary alloc] init];
    [body addEntriesFromDictionary:bodyParams];
    body[@"token"] = [self md5String:[self base64String:signString]];
    
    return body;
}

- (NSURLSessionTask *)requestWithPath:(NSString *)path
                               method:(NSString *)method
                           pathParams:(NSDictionary *)pathParams
                          queryParams:(NSDictionary *)queryParams
                         headerParams:(NSDictionary *)headerParams
                                 body:(id)body
                   requestContentType:(NSString *)requestContentType
                  responseContentType:(NSString *)responseContentType
                         responseType:(NSString *)responseType
                      completionBlock:(void (^)(id, NSError *))completionBlock
{
    AFHTTPRequestSerializer <AFURLRequestSerialization> *requestSerializer = [self requestSerializerForRequestContentType:requestContentType];
    
    __weak id<XTSanitizer> sanitizer = self.sanitizer;
    pathParams = [sanitizer sanitizeForSerialization:pathParams];
    queryParams = [sanitizer sanitizeForSerialization:queryParams];
    headerParams = [sanitizer sanitizeForSerialization:headerParams];
    if (![body isKindOfClass:[NSData class]]) {
        body = [sanitizer sanitizeForSerialization:body];
    }
    
    NSMutableString *resourcePath = [NSMutableString stringWithString:path];
    [pathParams enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString * safeString = ([obj isKindOfClass:[NSString class]]) ? obj : [NSString stringWithFormat:@"%@", obj];
        safeString = XTPercentEscapedStringFromString(safeString);
        [resourcePath replaceCharactersInRange:[resourcePath rangeOfString:[NSString stringWithFormat:@"{%@}", key]] withString:safeString];
    }];
    
    NSString *pathWithQueryParams = [self pathWithQueryParamsToString:resourcePath queryParams:queryParams];
    if ([pathWithQueryParams hasPrefix:@"/"]) {
        pathWithQueryParams = [pathWithQueryParams substringFromIndex:1];
    }
    
    NSString *urlString = [[NSURL URLWithString:pathWithQueryParams relativeToURL:self.baseURL] absoluteString];
    NSError *requestCreateError = nil;
    
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:method URLString:urlString parameters:body error:&requestCreateError];
    if (!request) {
        completionBlock(nil, requestCreateError);
        return nil;
    }
    
    if ([headerParams count] > 0) {
        for (NSString *key in [headerParams keyEnumerator]) {
            [request setValue:[headerParams valueForKey:key] forHTTPHeaderField:key];
        }
    }

    __weak typeof(self) weakSelf = self;
    NSURLSessionTask *task = [self taskWithRequest:request completionBlock:^(id data, NSError *error) {
        if (error) {
            completionBlock(nil, error);
        }
        
        id jsonObject = data;
        if (jsonObject && [jsonObject isKindOfClass:[NSDictionary class]]) {
            NSInteger code = [jsonObject[@"rtCode"] integerValue];
            if (code >= 18001 && code <= 18018) {
                id businessData = jsonObject[@"rtData"];
                if (businessData) {
                    NSError *serializationError;
                    id response = [weakSelf.responseDeserializer deserialize:businessData class:responseType error:&serializationError];
                    completionBlock(response, serializationError);
                } else {
                    completionBlock(nil, nil);
                }
            } else {
                id businessMessage = jsonObject[@"rtMessage"] ? : @"业务错误";
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey : businessMessage};
                NSError *businessDataError = [NSError errorWithDomain:XTBusinessDataErrorDomain code:code userInfo:userInfo];
                completionBlock(nil, businessDataError);
            }
        } else {
            NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Received response [%@] is not an object of type NSDictionary", nil), jsonObject];
            NSDictionary *userInfo = @{XTResponseObjectErrorKey : message};
            NSError *serializationError = [NSError errorWithDomain:XTDeserializationErrorDomain code:XTTypeMismatchErrorCode userInfo:userInfo];
            completionBlock(nil, serializationError);
        }
    }];
    
    [task resume];
    
    return task;
}

- (AFHTTPRequestSerializer <AFURLRequestSerialization> *)requestSerializerForRequestContentType:(NSString *)requestContentType
{
    AFHTTPRequestSerializer <AFURLRequestSerialization> *serializer = self.requestSerializerForContentType[requestContentType];
    if (!serializer) {
        NSAssert(NO, @"Unsupported request content type %@", requestContentType);
        serializer = [AFHTTPRequestSerializer serializer];
    }
    [serializer setValue:requestContentType forHTTPHeaderField:@"Content-Type"];
    serializer.timeoutInterval = self.timeoutInterval;
    return serializer;
}

- (NSString *)pathWithQueryParamsToString:(NSString *)path queryParams:(NSDictionary *)queryParams
{
    if (queryParams.count == 0) {
        return path;
    }
    
    NSString *separator = nil;
    NSUInteger counter = 0;
    
    NSMutableString *requestUrl = [NSMutableString stringWithFormat:@"%@", path];
    
    for (NSString *key in [queryParams keyEnumerator]) {
        separator = (counter == 0) ? @"?" : @"&";

        id queryParam = [queryParams valueForKey:key];
        if (!queryParam) {
            continue;
        }
        NSString *safeKey = XTPercentEscapedStringFromString(key);
        if ([queryParam isKindOfClass:[NSString class]]) {
            [requestUrl appendString:[NSString stringWithFormat:@"%@%@=%@", separator, safeKey, XTPercentEscapedStringFromString(queryParam)]];
        } else {
            NSString *safeValue = XTPercentEscapedStringFromString([NSString stringWithFormat:@"%@", queryParam]);
            [requestUrl appendString:[NSString stringWithFormat:@"%@%@=%@", separator, safeKey, safeValue]];
        }
        counter += 1;
    }
    
    return requestUrl;
}

- (NSURLSessionDataTask *)taskWithRequest:(NSURLRequest *)request completionBlock:(void (^)(id, NSError *))completionBlock
{
    NSURLSessionDataTask *task = [self dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (!error) {
            completionBlock(responseObject, nil);
            return;
        }
        
        NSMutableDictionary *userInfo = [error.userInfo mutableCopy];
        if (responseObject) {
            userInfo[XTResponseObjectErrorKey] = responseObject;
        }
        NSError *augmentedError = [error initWithDomain:error.domain code:error.code userInfo:userInfo];
        completionBlock(nil, augmentedError);
    }];
    
    return task;
}

- (NSString *)base64String:(NSString *)string
{
    // ISO8859-1编码
    NSData *data = [string dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingISOLatin1)];
    
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)md5String:(NSString *)string
{
    const char *input = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    
    return digest;
}

@end
