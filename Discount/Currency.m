//
//  Currency.m
//  Discount
//
//  Created by Mikkel Petersen on 3/28/15.
//  Copyright (c) 2015 Mikkel Vester Petersen. All rights reserved.
//

#import "Currency.h"

enum {
    theBrazilianReal,
    theBritishPound,
    theCanadianDollar,
    theChineseYuan,
    theDanishKroner,
    theEuro,
    theIndianRupee,
    theJapaneseYen,
    theMexicanPeso,
    theRussianRuble,
    theUSDollar
};

Currency* _currensies[11];

@implementation Currency

@synthesize entity = _entity,
            code = _code,
            currency = _currency,
            formatter = _formatter,
            decimalPlaces = _decimalPlaces,
            symbol = _symbol;

-(Currency*) initWithEntity: (NSString*) theEntity
                   currency: (NSString*) aCurrency
                       code: (NSString*) theCode
              decimalPlaces: (int) places
                     symbol: (NSString*) theSymbol
{
    self = [super init];
    
    if (self) {
        _entity = theEntity;
        _currency = aCurrency;
        _code = theCode;
        _decimalPlaces = places;
        _symbol = theSymbol;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        _entity = [aDecoder decodeObjectForKey:@"entity"];
        _currency = [aDecoder decodeObjectForKey:@"currency"];
        _code = [aDecoder decodeObjectForKey:@"code"];
        _decimalPlaces = [aDecoder decodeIntForKey:@"decimalPlaces"];
        _symbol = [aDecoder decodeObjectForKey:@"symbol"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.entity forKey:@"entity"];
    [aCoder encodeObject:self.currency forKey:@"currency"];
    [aCoder encodeObject:self.code forKey:@"code"];
    [aCoder encodeInt:self.decimalPlaces forKey:@"decimalPlaces"];
    [aCoder encodeObject:self.symbol forKey:@"symbol"];
}

-(NSNumberFormatter*)formatter
{
    _formatter = [[NSNumberFormatter alloc] init];
    _formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    _formatter.currencyCode = self.code;
    
    return _formatter;
}

+(Currency *)theBrazilianReal
{
    if (_currensies[theBrazilianReal] == nil) {
        _currensies[theBrazilianReal] = [[Currency alloc] initWithEntity:@"BRAZIL"
                                                                currency:@"Brazilian Real"
                                                                    code:@"BRL"
                                                           decimalPlaces:2
                                                                  symbol:@"R$"];
    }
    return _currensies[theBrazilianReal];
}

+(Currency *)theBritishPound
{
    if (_currensies[theBritishPound] == nil) {
        _currensies[theBritishPound] = [[Currency alloc] initWithEntity:@"UNITED KINGDOM"
                                                               currency:@"Pound Sterling"
                                                                   code:@"GBP"
                                                          decimalPlaces:2
                                                                 symbol:@"£"];
    }
    return _currensies[theBritishPound];
}
    
+(Currency *)theCanadianDollar
{
    if (_currensies[theCanadianDollar] == nil) {
        _currensies[theCanadianDollar] = [[Currency alloc] initWithEntity:@"CANADA"
                                                                 currency:@"Canadian Dollar"
                                                                     code:@"CAD"
                                                            decimalPlaces:2
                                                                   symbol:@"$"];
    }
    return _currensies[theCanadianDollar];
}

+(Currency *)theChineseYuan
{
    if (_currensies[theChineseYuan] == nil) {
        _currensies[theChineseYuan] = [[Currency alloc] initWithEntity:@"CHINA"
                                                              currency:@"Yuan Renminbi"
                                                                  code:@"CNY"
                                                         decimalPlaces:2
                                                                symbol:@"¥"];
    }
    return _currensies[theChineseYuan];
}

+(Currency *)theDanishKroner
{
    if (_currensies[theDanishKroner] == nil) {
        _currensies[theDanishKroner] = [[Currency alloc] initWithEntity:@"DENMARK"
                                                               currency:@"Danish Kroner"
                                                                   code:@"DKK"
                                                          decimalPlaces:2
                                                                 symbol:@"kr"];
    }
    return _currensies[theDanishKroner];
}

+(Currency *)theEuro
{
    if (_currensies[theEuro] == nil) {
        _currensies[theEuro] = [[Currency alloc] initWithEntity:@"EUROPEAN UNION"
                                                       currency:@"Euro"
                                                           code:@"EUR"
                                                  decimalPlaces:2
                                                         symbol:@"€"];
    }
    return _currensies[theEuro];
}

+(Currency *)theIndianRupee
{
    if (_currensies[theIndianRupee] == nil) {
        _currensies[theIndianRupee] = [[Currency alloc] initWithEntity:@"INDIA"
                                                              currency:@"Indian Rupee"
                                                                  code:@"INR"
                                                         decimalPlaces:2
                                                                symbol:@"₹"];
    }
    return _currensies[theIndianRupee];
}

+(Currency *)theJapaneseYen
{
    if (_currensies[theJapaneseYen] == nil) {
        _currensies[theJapaneseYen] = [[Currency alloc] initWithEntity:@"JAPAN"
                                                              currency:@"Yen"
                                                                  code:@"JPY"
                                                         decimalPlaces:0
                                                                symbol:@"¥"];
    }
    return _currensies[theJapaneseYen];
}

+(Currency *)theMexicanPeso
{
    if (_currensies[theMexicanPeso] == nil) {
        _currensies[theMexicanPeso] = [[Currency alloc] initWithEntity:@"MEXICO"
                                                              currency:@"Mexican Peso"
                                                                  code:@"MXN"
                                                         decimalPlaces:2
                                                                symbol:@"$"];
    }
    return _currensies[theMexicanPeso];
}

+(Currency *)theRussianRuble
{
    if (_currensies[theRussianRuble] == nil) {
        _currensies[theRussianRuble] = [[Currency alloc] initWithEntity:@"RUSSIAN FEDERATION"
                                                               currency:@"Russian Ruble"
                                                                   code:@"RUB"
                                                          decimalPlaces:2
                                                                 symbol:@"руб"];
    }
    return _currensies[theRussianRuble];
}

+(Currency *)theUSDollar
{
    if (_currensies[theUSDollar] == nil) {
        _currensies[theUSDollar] = [[Currency alloc] initWithEntity:@"UNITED STATES"
                                                           currency:@"US Dollar"
                                                               code:@"USD"
                                                      decimalPlaces:2
                                                             symbol:@"$"];
    }
    return _currensies[theUSDollar];
}

@end
