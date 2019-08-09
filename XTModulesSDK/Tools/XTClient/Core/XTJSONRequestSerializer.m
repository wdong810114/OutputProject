//
//  XTJSONRequestSerializer.m
//  XTModulesSDK
//
//  Created by wdd on 2019/7/24.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTJSONRequestSerializer.h"

@implementation XTJSONRequestSerializer

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(id)parameters
                                        error:(NSError *__autoreleasing *)error
{
    if (!parameters) {
        return request;
    }

    if ([parameters isKindOfClass:[NSArray class]] || [parameters isKindOfClass:[NSDictionary class]]) {
        return [super requestBySerializingRequest:request withParameters:parameters error:error];
    }
    
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    if ([parameters isKindOfClass:[NSData class]]) {
        [mutableRequest setHTTPBody:parameters];
    } else {
        [mutableRequest setHTTPBody:[parameters dataUsingEncoding:self.stringEncoding]];
    }
    return mutableRequest;
}


@end
