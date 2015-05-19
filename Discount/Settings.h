//
//  Settings.h
//  Discount
//
//  Created by Mikkel Petersen on 4/10/15.
//  Copyright (c) 2015 Mikkel Vester Petersen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExchangeRate.h"

@interface Settings : NSObject

@property ExchangeRate* currentExchangeRate;

+(Settings*) sharedSingletonInstance;

@end
