//
//  XTLifePaymentPayBillMoneyCell.m
//  XTModulesSDK
//
//  Created by wdd on 2019/8/20.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTLifePaymentPayBillMoneyCell.h"

#import "XTMacro.h"

@interface XTLifePaymentPayBillMoneyCell () <UITextFieldDelegate>

@end

@implementation XTLifePaymentPayBillMoneyCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (IBAction)textFieldEditingChanged:(id)sender
{
    if (sender == self.moneyTextField) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(lifePaymentPayBillMoneyCell:didChangeMoney:)]) {
            [self.delegate lifePaymentPayBillMoneyCell:self didChangeMoney:self.moneyTextField.text];
        }
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.moneyTextField) {
        NSCharacterSet *characterSet;
        NSUInteger dotLocation = [textField.text rangeOfString:@"."].location;
        
        if (NSNotFound == dotLocation && range.location != 0) {
            characterSet = [[NSCharacterSet characterSetWithCharactersInString:XTDecimalCharacterSet] invertedSet];
        } else {
            characterSet = [[NSCharacterSet characterSetWithCharactersInString:XTDigitalCharacterSet] invertedSet];
        }
        
        NSString *filteredString = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
        if (![string isEqualToString:filteredString]) {
            return NO;
        }
        
        NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSArray *components = [toBeString componentsSeparatedByString:@"."];
        if ([components count] > 1 && [components[1] length] > 2) {
            return NO;
        }
    }
    
    return YES;
}

@end
