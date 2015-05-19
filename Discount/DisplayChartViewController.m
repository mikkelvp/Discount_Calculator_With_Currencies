//
//  DisplayChartViewController.m
//  Discount
//
//  Created by Mikkel Petersen on 2/19/15.
//  Copyright (c) 2015 Mikkel Vester Petersen. All rights reserved.
//

#import "DisplayChartViewController.h"
#import "Item.h"
#import "ExchangeRate.h"
#import "Settings.h"

@implementation DisplayChartViewController

@synthesize item = _item;

-(void)viewDidLoad{
    _item = [Item sharedSingletonInstance];
}

- (BOOL)isiOS8OrAbove {
    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"8.0"
                                                                       options: NSNumericSearch];
    return (order == NSOrderedSame || order == NSOrderedDescending);
}

-(void)viewDidAppear:(BOOL)animated
{
    Settings* settings = [Settings sharedSingletonInstance];
    ExchangeRate* rate = settings.currentExchangeRate;
    
    if (_item.originalPriceWithTax && _item.discountPriceWithTax) {
        NSDecimalNumber* discountPercentage = [[_item.originalPriceWithTax decimalNumberBySubtracting:_item.discountPriceWithTax]
                                               decimalNumberByDividingBy:_item.originalPriceWithTax];
        NSDecimalNumber* oneHundred = [NSDecimalNumber decimalNumberWithString:@"100"];
        NSDecimalNumberHandler* round = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
        _Chart.discountPercentage = discountPercentage.floatValue;
        _Chart.discountPrice = [NSString stringWithFormat:@"Discount: %@\n%@%%", [rate.dstCurrency.formatter stringFromNumber:[[_item discountPriceWithTax] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithDecimal:rate.rate.decimalValue]]], [oneHundred decimalNumberBySubtracting:[discountPercentage decimalNumberByMultiplyingBy:oneHundred] withBehavior:round]];
        _Chart.originalPrice = [NSString stringWithFormat:@"Original:\n%@", [rate.dstCurrency.formatter stringFromNumber:[[_item originalPriceWithTax] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithDecimal:rate.rate.decimalValue]]]];
        _Chart.savings = [NSString stringWithFormat:@"Savings: %@\n%@%%", [rate.dstCurrency.formatter stringFromNumber:[[_item calcTotalSavings] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithDecimal:rate.rate.decimalValue]]], [discountPercentage decimalNumberByMultiplyingBy:oneHundred withBehavior:round]];
    }
    else {
        // Display alert
        NSString* title = @"Nothing to display";
        NSString* msg = @"No discount calculation is made. Nothing to see here. Make a calculation and come back.";
        if ([self isiOS8OrAbove]) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                           message:msg
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title
                                                                 message:msg
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles: nil];
            [alertView show];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
