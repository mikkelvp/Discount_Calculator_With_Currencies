//
//  ExchangeRate.m
//  Discount
//
//  Created by Mikkel Petersen on 3/29/15.
//  Copyright (c) 2015 Mikkel Vester Petersen. All rights reserved.
//

#import "ExchangeRate.h"

@implementation ExchangeRate

@synthesize srcCurrency = _srcCurrency,
            dstCurrency = _dstCurrency,
            rate = _rate,
            lastFetchedOn = _lastFetchedOn,
            expireAfterHours = _expireAfterHours,
            decimalHandler = _decimalHandler;


-(ExchangeRate*)initWithSrcCurrency:(Currency*)aSrc
                        destination:(Currency*)aDst
{
    self = [super init];
    if (self) {
        _srcCurrency = aSrc;
        _dstCurrency = aDst;
        _decimalHandler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers
                                                                                 scale:_dstCurrency.decimalPlaces
                                                                      raiseOnExactness:NO
                                                                       raiseOnOverflow:NO
                                                                      raiseOnUnderflow:NO
                                                                   raiseOnDivideByZero:NO];
        
        _rate = @-1;
        _lastFetchedOn = [NSDate dateWithTimeIntervalSince1970:0];
        _expireAfterHours = @25;
        
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        _srcCurrency = [aDecoder decodeObjectForKey:@"srcCurrency"];
        _dstCurrency = [aDecoder decodeObjectForKey:@"dstCurrency"];
        _rate = [aDecoder decodeObjectForKey:@"rate"];
        _lastFetchedOn = [aDecoder decodeObjectForKey:@"lastFetchedOn"];
        _expireAfterHours = [aDecoder decodeObjectForKey:@"expireAfterHours"];
        _decimalHandler = [aDecoder decodeObjectForKey:@"decimalHandler"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.srcCurrency forKey:@"srcCurrency"];
    [aCoder encodeObject:self.dstCurrency forKey:@"dstCurrency"];
    [aCoder encodeObject:self.rate forKey:@"rate"];
    [aCoder encodeObject:self.lastFetchedOn forKey:@"lastFetchedOn"];
    [aCoder encodeObject:self.expireAfterHours forKey:@"expireAfterHours"];
    [aCoder encodeObject:self.decimalHandler forKey:@"decimalHandler"];
}

// update rate async
-(BOOL)updateWithDelegate:(id<NSURLConnectionDataDelegate>)del
{
    // only update if rate expired
    if (self.lastFetchedOn.timeIntervalSinceNow > (self.expireAfterHours.doubleValue * -3600.0)) {
        return NO;
    }
    
    // generate request
    NSString *yqlString = [NSString stringWithFormat:@"select * from yahoo.finance.xchange where pair in (\"%@%@\")",
                           [self.srcCurrency code], [self.dstCurrency code]];
    NSString *urlString = [NSString stringWithFormat:@"https://query.yahooapis.com/v1/public/yql?q=%@&format=json&diagnostics=true&env=store://datatables.org/alltableswithkeys&callback=", [yqlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];

    
    NSURL *RESTQueryURL = [NSURL URLWithString: urlString]; // https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22USDDKK%22)&format=json&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=
    NSURLRequest *request = [NSURLRequest requestWithURL: RESTQueryURL];
    // perform request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:del];

    if (conn) {
        NSLog(@"%@", conn);
    }
    
    return YES;
}

@end
