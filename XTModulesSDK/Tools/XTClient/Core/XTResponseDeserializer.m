//
//  XTResponseDeserializer.m
//  XTModulesSDK
//
//  Created by wdd on 2019/7/26.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTResponseDeserializer.h"

#import <JSONModel/JSONModel.h>
#import <ISO8601/ISO8601.h>

NSString * const XTDeserializationErrorDomain = @"XTDeserializationErrorDomain";

NSInteger const XTTypeMismatchErrorCode = 190723;
NSInteger const XTEmptyValueOccurredErrorCode = 190724;
NSInteger const XTUnknownResponseErrorCode = 190725;

@interface XTResponseDeserializer ()

@property (nonatomic, strong) NSNumberFormatter *numberFormatter;
@property (nonatomic, strong) NSArray *primitiveTypes;
@property (nonatomic, strong) NSArray *basicTypes;
@property (nonatomic, strong) NSArray *dataTypes;

@property (nonatomic, strong) NSRegularExpression *arrayOfModelsRegularExpression;
@property (nonatomic, strong) NSRegularExpression *arrayOfPrimitivesRegularExpression;
@property (nonatomic, strong) NSRegularExpression *dictOfModelsRegularExpression;
@property (nonatomic, strong) NSRegularExpression *dictOfPrimitivesRegularExpression;

@end

@implementation XTResponseDeserializer

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        _numberFormatter = formatter;
        _primitiveTypes = @[@"NSString", @"NSDate", @"NSNumber"];
        _basicTypes = @[@"NSObject", @"id"];
        _dataTypes = @[@"NSData"];
        
        _arrayOfModelsRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"NSArray<(.+)>" options:NSRegularExpressionCaseInsensitive error:nil];
        _arrayOfPrimitivesRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"NSArray\\* /\\* (.+) \\*/" options:NSRegularExpressionCaseInsensitive error:nil];
        _dictOfModelsRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"NSDictionary\\<(.+?), (.+)*\\>" options:NSRegularExpressionCaseInsensitive error:nil];
        _dictOfPrimitivesRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"NSDictionary\\* /\\* (.+?), (.+) \\*/" options:NSRegularExpressionCaseInsensitive error:nil];
    }
    
    return self;
}

- (id)deserialize:(id)data class:(NSString *)className error:(NSError **)error
{
    if (!data || !className) {
        return nil;
    }
    
    if ([className hasSuffix:@"*"]) {
        className = [className substringToIndex:[className length] - 1];
    }
    if ([self.dataTypes containsObject:className]) {
        return data;
    }
    id jsonData = nil;
    if ([data isKindOfClass:[NSData class]]) {
        jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:error];
    } else {
        jsonData = data;
    }
    if (!jsonData) {
        jsonData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    } else if ([jsonData isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    if ([self.basicTypes containsObject:className]) {
        return jsonData;
    }
    
    if ([self.primitiveTypes containsObject:className]) {
        return [self deserializePrimitiveValue:jsonData class:className error:error];
    }
    
    NSTextCheckingResult *match = nil;
    NSRange range = NSMakeRange(0, [className length]);

    // 模型类型数组
    match = [self.arrayOfModelsRegularExpression firstMatchInString:className options:0 range:range];
    if (match) {
        NSString *innerType = [className substringWithRange:[match rangeAtIndex:1]];
        return [self deserializeArrayValue:jsonData innerType:innerType error:error];
    }
    
    // 原始类型数组
    match = [self.arrayOfPrimitivesRegularExpression firstMatchInString:className options:0 range:range];
    if (match) {
        NSString *innerType = [className substringWithRange:[match rangeAtIndex:1]];
        return [self deserializeArrayValue:jsonData innerType:innerType error:error];
    }
    
    // 模型类型字典
    match = [self.dictOfModelsRegularExpression firstMatchInString:className options:0 range:range];
    if (match) {
        NSString *valueType = [className substringWithRange:[match rangeAtIndex:2]];
        return [self deserializeDictionaryValue:jsonData valueType:valueType error:error];
    }
    
    // 原始类型字典
    match = [self.dictOfPrimitivesRegularExpression firstMatchInString:className options:0 range:range];
    if (match) {
        NSString *valueType = [className substringWithRange:[match rangeAtIndex:2]];
        return [self deserializeDictionaryValue:jsonData valueType:valueType error:error];
    }
    
    // 模型
    Class ModelClass = NSClassFromString(className);
    if ([ModelClass instancesRespondToSelector:@selector(initWithDictionary:error:)]) {
        return [(JSONModel *)[ModelClass alloc] initWithDictionary:jsonData error:error];
    }
    
    if (error) {
        *error = [self unknownResponseErrorWithExpectedType:className data:jsonData];
    }
    
    return nil;
}

- (id)deserializePrimitiveValue:(id)data class:(NSString *)className error:(NSError **)error
{
    if ([className isEqualToString:@"NSString"]) {
        return [NSString stringWithFormat:@"%@", data];
    } else if ([className isEqualToString:@"NSDate"]) {
        return [self deserializeDateValue:data error:error];
    } else if ([className isEqualToString:@"NSNumber"]) {
        if ([data isKindOfClass:[NSNumber class]]) {
            return data;
        } else if ([data isKindOfClass:[NSString class]]) {
            if ([[data lowercaseString] isEqualToString:@"true"] || [[data lowercaseString] isEqualToString:@"false"]) {
                return @([data boolValue]);
            } else {
                NSNumber *formattedValue = [self.numberFormatter numberFromString:data];
                if (!formattedValue && [data length] > 0 && error) {
                    *error = [self typeMismatchErrorWithExpectedType:className data:data];
                }
                return formattedValue;
            }
        }
    }
    if (error) {
        *error = [self typeMismatchErrorWithExpectedType:className data:data];
    }
    return nil;
}

- (id)deserializeArrayValue:(id)data innerType:(NSString *)innerType error:(NSError **)error
{
    if (![data isKindOfClass:[NSArray class]]) {
        if (error) {
            *error = [self typeMismatchErrorWithExpectedType:NSStringFromClass([NSArray class]) data:data];
        }
        return nil;
    }
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:[(NSArray *)data count]];
    for (id obj in data) {
        id arrObj = [self deserialize:obj class:innerType error:error];
        if (arrObj) {
            [resultArray addObject:arrObj];
        } else if ([obj isKindOfClass:[NSNull class]]) {
            if (self.treatNullAsError) {
                if (error) {
                    *error = [self emptyValueOccurredError];
                }
                resultArray = nil;
                break;
            }
        } else {
            resultArray = nil;
            break;
        }
    }
    return resultArray;
};

- (id)deserializeDictionaryValue:(id)data valueType:(NSString *)valueType error:(NSError **)error
{
    if (![data isKindOfClass:[NSDictionary class]]) {
        if (error) {
            *error = [self typeMismatchErrorWithExpectedType:NSStringFromClass([NSDictionary class]) data:data];
        }
        return nil;
    }
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionaryWithCapacity:[(NSDictionary *)data count]];
    for (id key in [data allKeys]) {
        id obj = [data valueForKey:key];
        id dictObj = [self deserialize:obj class:valueType error:error];
        if (dictObj) {
            [resultDict setValue:dictObj forKey:key];
        } else if ([obj isKindOfClass:[NSNull class]]) {
            if (self.treatNullAsError) {
                if (error) {
                    *error = [self emptyValueOccurredError];
                }
                resultDict = nil;
                break;
            }
        } else {
            resultDict = nil;
            break;
        }
    }
    return resultDict;
}

- (id)deserializeDateValue:(id)data error:(NSError **)error
{
    NSDate *date = [NSDate dateWithISO8601String:data];
    if (!date && [data length] > 0 && error) {
        *error = [self typeMismatchErrorWithExpectedType:NSStringFromClass([NSDate class]) data:data];
    }
    return date;
};

- (NSError *)typeMismatchErrorWithExpectedType:(NSString *)expected data:(id)data
{
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Received response [%@] is not an object of type %@", nil), data, expected];
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : message};
    return [NSError errorWithDomain:XTDeserializationErrorDomain code:XTTypeMismatchErrorCode userInfo:userInfo];
}

- (NSError *)emptyValueOccurredError
{
    NSString *message = NSLocalizedString(@"Received response contains null value in dictionary or array response", nil);
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : message};
    return [NSError errorWithDomain:XTDeserializationErrorDomain code:XTEmptyValueOccurredErrorCode userInfo:userInfo];
}

- (NSError *)unknownResponseErrorWithExpectedType:(NSString *)expected data:(id)data
{
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Unknown response expected type %@ [response: %@]", nil), expected, data];
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : message};
    return [NSError errorWithDomain:XTDeserializationErrorDomain code:XTUnknownResponseErrorCode userInfo:userInfo];
}

@end
