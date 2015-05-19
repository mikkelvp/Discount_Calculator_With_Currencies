//
//  Item.m
//  Discount
//
//  Created by Mikkel Petersen on 2/19/15.
//  Copyright (c) 2015 Mikkel Vester Petersen. All rights reserved.
//

#import "Item.h"

static Item* _sharedSingletonInstance;

@implementation Item

@synthesize price = _price;
@synthesize dollarsOff = _dollarsOff;
@synthesize discount = _discount;
@synthesize addDisc = _addDisc;
@synthesize tax = _tax;
@synthesize originalPriceWithTax = _originalPriceWithTax;
@synthesize discountPriceWithTax = _discountPriceWithTax;
@synthesize totalSavings = _totalSavings;

-(Item *) init {
    self = [super init];
    return self;
}

+(void) initialize
{
    if ([Item class] == self) {
        _sharedSingletonInstance = [self new];
    }
}

// Return singleton instance
+(Item *) sharedSingletonInstance
{
    return _sharedSingletonInstance;
}

-(NSDecimalNumber *)calcDiscountPrice {
    _discountPriceWithTax = [NSDecimalNumber zero];
    NSDecimalNumber* oneHundred = [NSDecimalNumber decimalNumberWithString:@"100"];
    NSDecimalNumber* tax = [NSDecimalNumber zero];
    
    if (_price > 0) {
        
        // Get tax from price
        if (_tax.doubleValue > 0.0 && _tax != [NSDecimalNumber notANumber]) {
            //result *= (tax/100) + 1;
            tax = [_price decimalNumberByMultiplyingBy:[_tax decimalNumberByDividingBy:oneHundred]];
        }
        
        // Subtract dollars off
        if (_dollarsOff.doubleValue > 0.0 && _price != [NSDecimalNumber notANumber] && _dollarsOff != [NSDecimalNumber notANumber]) {
            //_discountPriceWithTax = price - dollarsOff;
            _discountPriceWithTax = [_price decimalNumberBySubtracting:_dollarsOff];
        }
        
        // Apply discount
        if (_discount.doubleValue > 0.0 && _discount != [NSDecimalNumber notANumber]) {
            if (_discountPriceWithTax.integerValue == 0) {
                _discountPriceWithTax = _price;
            }
            //_discountPriceWithTax *= (100-discount)/100;
            _discountPriceWithTax = [_discountPriceWithTax decimalNumberByMultiplyingBy:
                      [[oneHundred decimalNumberBySubtracting:_discount] decimalNumberByDividingBy:oneHundred]];
            
            // Apply additional discount
            if (_addDisc.doubleValue > 0.0 && _addDisc != [NSDecimalNumber notANumber]) {
                //_discountPriceWithTax *= (100-addDisc)/100;
                _discountPriceWithTax = [_discountPriceWithTax decimalNumberByMultiplyingBy:
                          [[oneHundred decimalNumberBySubtracting:_addDisc] decimalNumberByDividingBy:oneHundred]];
            }
        }
        // Apply tax
        _discountPriceWithTax = [_discountPriceWithTax decimalNumberByAdding:tax];
    }
    
    return _discountPriceWithTax;
}

-(NSDecimalNumber *)calcOriginalPrice {
    _originalPriceWithTax = [NSDecimalNumber zero];
    NSDecimalNumber* oneHundred = [NSDecimalNumber decimalNumberWithString:@"100"];
    
    if (_price > 0 && _price != [NSDecimalNumber notANumber]) {
        _originalPriceWithTax = _price;
        
        if (_tax > 0 && _tax != [NSDecimalNumber notANumber]) {
            //_originalPriceWithTax *= (tax/100) + 1;
            _originalPriceWithTax = [_originalPriceWithTax decimalNumberByMultiplyingBy:
                      [[_tax decimalNumberByDividingBy:oneHundred] decimalNumberByAdding:[NSDecimalNumber one]]];
        }
    }
    
    return _originalPriceWithTax;
}

-(NSDecimalNumber *)calcTotalSavings {
    if (_originalPriceWithTax != [NSDecimalNumber notANumber] && _discountPriceWithTax != [NSDecimalNumber notANumber]) {
        _totalSavings = [_originalPriceWithTax decimalNumberBySubtracting:_discountPriceWithTax];
    }
    else {
        _totalSavings = [NSDecimalNumber zero];
    }    
    
    return _totalSavings;
}



@end
