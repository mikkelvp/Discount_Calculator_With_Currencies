//
//  UITextField+NextTextField.m
//  Discount
//
//  Created by Mikkel Petersen on 3/2/15.
//  Copyright (c) 2015 Mikkel Vester Petersen. All rights reserved.
//

#import "UITextField+NextTextField.h"
#import <objc/runtime.h>

static Byte nextDefaultHashKey;
static Byte prevDefaultHashKey;

@implementation UITextField (NextTextField)

-(UITextField*) nextTextField
{
    return objc_getAssociatedObject( self, &nextDefaultHashKey );
}

-(void) setNextTextField: (UITextField *)nextTextField
{
    objc_setAssociatedObject( self, &nextDefaultHashKey, nextTextField,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

-(UITextField*) prevTextField
{
    return objc_getAssociatedObject( self, &prevDefaultHashKey );
}

-(void) setPrevTextField: (UITextField *)prevTextField
{
    objc_setAssociatedObject( self, &prevDefaultHashKey, prevTextField,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

@end
