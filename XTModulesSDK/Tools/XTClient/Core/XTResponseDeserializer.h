//
//  XTResponseDeserializer.h
//  XTModulesSDK
//
//  Created by wdd on 2019/7/26.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  反序列化错误域
 */
extern NSString * const XTDeserializationErrorDomain;

/**
 *  反序列化类型不匹配错误码
 */
extern NSInteger const XTTypeMismatchErrorCode;

/**
 *  反序列化出现空值错误码
 */
extern NSInteger const XTEmptyValueOccurredErrorCode;

/**
 *  反序列化未知响应错误码
 */
extern NSInteger const XTUnknownResponseErrorCode;

@protocol XTResponseDeserializer <NSObject>

/**
 *  将给定数据反序列化到Objective-C对象。
 *
 *  @param data 将被反序列化的数据
 *  @param className Objective-C对象的类型
 *  @param error 错误
 *
 *  @return Objective-C对象
 */
- (id)deserialize:(id)data class:(NSString *)className error:(NSError **)error;

@end

@interface XTResponseDeserializer : NSObject <XTResponseDeserializer>

/**
 *  如果字典或数组中出现空值，如果设置为“是”，则整个响应将无效，否则将被忽略。
 *
 *  @default NO
 */
@property (nonatomic, assign) BOOL treatNullAsError;

@end
