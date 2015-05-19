//
//  Currency.h
//  Discount
//
//  Created by Mikkel Petersen on 3/28/15.
//  Copyright (c) 2015 Mikkel Vester Petersen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Currency : NSObject <NSCoding>

@property (nonatomic, readonly) NSString* entity;
@property (nonatomic, readonly) NSString* currency;
@property (nonatomic, readonly) NSString* code;
@property (nonatomic, readonly) int decimalPlaces;
@property (nonatomic, readonly) NSNumberFormatter* formatter;
@property (nonatomic, readonly) NSString* symbol;

-(id)initWithCoder:(NSCoder *)aDecoder;
-(void)encodeWithCoder:(NSCoder *)aCoder;
-(NSNumberFormatter*)formatter;

+(Currency*) theBrazilianReal;
+(Currency*) theBritishPound;
+(Currency*) theCanadianDollar;
+(Currency*) theChineseYuan;
+(Currency*) theDanishKroner;
+(Currency*) theEuro;
+(Currency*) theIndianRupee;
+(Currency*) theJapaneseYen;
+(Currency*) theMexicanPeso;
+(Currency*) theRussianRuble;
+(Currency*) theUSDollar;

@end
