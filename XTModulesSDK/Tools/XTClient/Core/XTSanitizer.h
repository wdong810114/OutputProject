//
//  XTSanitizer.h
//  XTModulesSDK
//
//  Created by wdd on 2019/7/24.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * XTPercentEscapedStringFromString(NSString *string);

extern NSString * const kXTApplicationJSONType;

@protocol XTSanitizer <NSObject>

- (id)sanitizeForSerialization:(id)object;

+ (NSString *)stringFromDate:(id)date;

- (NSString *)selectHeaderAccepts:(NSArray *)accepts;
- (NSString *)selectHeaderContentTypes:(NSArray *)contentTypes;

@end

@interface XTSanitizer : NSObject <XTSanitizer>

@end
