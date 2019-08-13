//
//  XTRefuelTicketCell.h
//  XTModulesSDK
//
//  Created by wdd on 2019/8/9.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XTRefuelTicketModel.h"

@interface XTRefuelTicketCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *showLogoImageView;
@property (nonatomic, weak) IBOutlet UIImageView *lineCutoffImageView;
@property (nonatomic, weak) IBOutlet UIImageView *oilIconImageView;
@property (nonatomic, weak) IBOutlet UILabel *amountLabel;
@property (nonatomic, weak) IBOutlet UILabel *ticketNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *endTimeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *statusImageView;

@property (nonatomic, strong) XTRefuelTicketModel *model;

@end
