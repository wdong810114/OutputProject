//
//  XTClientConfiguration.h
//  XTModulesSDK
//
//  Created by wdd on 2019/7/24.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

@protocol XTClientConfiguration <NSObject>

@property (nonatomic, copy, readonly) NSString *host;

@property (nonatomic, strong, readonly) NSDictionary *defaultHeaders;

@end
