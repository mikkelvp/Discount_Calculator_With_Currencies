//
//  Item.h
//  Discount
//
//  Created by Mikkel Petersen on 2/19/15.
//  Copyright (c) 2015 Mikkel Vester Petersen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property NSDecimalNumber* price;
@property NSDecimalNumber* dollarsOff;
@property NSDecimalNumber* discount;
@property NSDecimalNumber* addDisc;
@property NSDecimalNumber* tax;
@property NSDecimalNumber* originalPriceWithTax;
@property NSDecimalNumber* discountPriceWithTax;
@property NSDecimalNumber* totalSavings;

+(Item*) sharedSingletonInstance;
-(NSDecimalNumber*)calcDiscountPrice;
-(NSDecimalNumber*)calcOriginalPrice;
-(NSDecimalNumber*)calcTotalSavings;

@end
