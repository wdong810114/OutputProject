//
//  XTRoundCornerCell.h
//  XTModulesSDK
//
//  Created by wdd on 2019/8/6.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * XTRoundCornerCellIdentifier;

#define XTCellShadowMarginHorizontal 5.0
#define XTCellShadowMarginVertical 5.0

typedef NS_ENUM(NSInteger, XTRoundCornerCellType)
{
    XTRoundCornerCellTypeSingle = 0,
    XTRoundCornerCellTypeTop,
    XTRoundCornerCellTypeMiddle,
    XTRoundCornerCellTypeBottom
};

@interface XTRoundCornerCell : UITableViewCell

@property (nonatomic, assign) XTRoundCornerCellType roundCornerCellType;

@property (nonatomic, assign) BOOL shadowHidden;
@property (nonatomic, assign) BOOL separatorHidden;

@end
