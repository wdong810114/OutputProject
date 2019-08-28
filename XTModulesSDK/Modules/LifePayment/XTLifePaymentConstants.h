//
//  XTLifePaymentConstants.h
//  XTModulesSDK
//
//  Created by wdd on 2019/8/15.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

typedef NS_ENUM(NSInteger, XTLifePaymentType) {
    XTLifePaymentTypeUnknown = 0,
    XTLifePaymentTypeWater = 1, // 水费
    XTLifePaymentTypeElectric,  // 电费
    XTLifePaymentTypeGas        // 燃气费
};

#define XTAccountTypeFromLifePaymentType(lifePaymentType) \
({ \
     NSString *accountType = nil; \
     switch (lifePaymentType) { \
         case XTLifePaymentTypeWater: \
             accountType = @"1"; \
             break; \
         case XTLifePaymentTypeElectric: \
             accountType = @"2"; \
             break; \
         case XTLifePaymentTypeGas: \
             accountType = @"3"; \
             break; \
         default: \
             break; \
     } \
     (accountType); \
 }) \

#define XTCompanyTypeFromLifePaymentType(lifePaymentType) \
({ \
     NSString *companyType = nil; \
     switch (lifePaymentType) { \
         case XTLifePaymentTypeWater: \
             companyType = @"1"; \
             break; \
         case XTLifePaymentTypeElectric: \
             companyType = @"2"; \
             break; \
         case XTLifePaymentTypeGas: \
             companyType = @"3"; \
             break; \
         default: \
             break; \
     } \
     (companyType); \
 }) \
