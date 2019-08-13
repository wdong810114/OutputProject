//
//  XTRefuelTicketCell.m
//  XTModulesSDK
//
//  Created by wdd on 2019/8/9.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTRefuelTicketCell.h"

#import "XTMacro.h"
#import "XTAppUtils.h"

@implementation XTRefuelTicketCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.showLogoImageView.image = [UIImage imageNamed:XTModulesSDKImage(@"refuel_ticket_cell_show_logo")];
    self.lineCutoffImageView.image = [UIImage imageNamed:XTModulesSDKImage(@"refuel_ticket_cell_line_cutoff")];
    self.oilIconImageView.image = [UIImage imageNamed:XTModulesSDKImage(@"refuel_ticket_cell_oil_icon")];
}

- (void)setModel:(XTRefuelTicketModel *)model
{
    _model = model;
    
    self.amountLabel.text = [NSString stringWithFormat:@"¥ %.2f", [model.amount floatValue]];
    self.ticketNameLabel.text = model.ticketName;
    
    if ([model.endTime longLongValue] != 0) {
        self.endTimeLabel.text = [NSString stringWithFormat:@"有效期至%@", [XTAppUtils formatYMDWithTimestamp:[model.endTime longLongValue]]];
    } else {
        self.endTimeLabel.text = @"长期有效";
    }
    
    switch ([model.status integerValue]) {
        case 2: // 已过期
        {
            self.statusImageView.image = [UIImage imageNamed:XTModulesSDKImage(@"refuel_ticket_cell_expired_icon")];
            self.statusImageView.hidden = NO;
        }
            break;
        case 3: // 已使用
        {
            self.statusImageView.image = [UIImage imageNamed:XTModulesSDKImage(@"refuel_ticket_cell_used_icon")];
            self.statusImageView.hidden = NO;
        }
            break;
            
        default:
        {
            self.statusImageView.image = nil;
            self.statusImageView.hidden = YES;
        }
            break;
    }
}

@end
