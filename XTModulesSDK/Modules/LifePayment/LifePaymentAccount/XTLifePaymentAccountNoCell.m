//
//  XTLifePaymentAccountNoCell.m
//  XTModulesSDK
//
//  Created by wdd on 2019/8/16.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTLifePaymentAccountNoCell.h"

@implementation XTLifePaymentAccountNoCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (IBAction)textFieldEditingChanged:(id)sender
{
    if (sender == self.noTextField) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(lifePaymentAccountNoCell:didChangeAccountNo:)]) {
            [self.delegate lifePaymentAccountNoCell:self didChangeAccountNo:self.noTextField.text];
        }
    }
}

@end
