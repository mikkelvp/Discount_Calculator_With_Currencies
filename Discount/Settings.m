//
//  Settings.m
//  Discount
//
//  Created by Mikkel Petersen on 4/10/15.
//  Copyright (c) 2015 Mikkel Vester Petersen. All rights reserved.
//

#import "Settings.h"

static Settings* _sharedSingletonInstance;

@implementation Settings

@synthesize currentExchangeRate;

-(Settings*) init {
    self = [super init];
    return self;
}

+(void) initialize
{
    if ([Settings class] == self) {
        _sharedSingletonInstance = [self new];
    }
}

// Return singleton instance
+(Settings*) sharedSingletonInstance
{
    return _sharedSingletonInstance;
}

@end
