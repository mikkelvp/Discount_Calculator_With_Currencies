//
//  ExchangeRate.h
//  Discount
//
//  Created by Mikkel Petersen on 3/29/15.
//  Copyright (c) 2015 Mikkel Vester Petersen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Currency.h"

@interface ExchangeRate : NSObject <NSCoding>

@property (retain) Currency* srcCurrency;
@property (retain) Currency* dstCurrency;
@property (retain) NSNumber* rate;
@property (retain) NSDate*   lastFetchedOn;
@property (retain) NSNumber* expireAfterHours;
@property (retain) NSDecimalNumberHandler* decimalHandler;

-(ExchangeRate*)initWithSrcCurrency:(Currency*)aSrc
                        destination:(Currency*)aDst;
-(id)initWithCoder:(NSCoder *)aDecoder;
-(void)encodeWithCoder:(NSCoder *)aCoder;
-(BOOL)updateWithDelegate:(id<NSURLConnectionDataDelegate>)del;

@end
