//
//  ChartView.m
//  Discount
//
//  Created by Mikkel Petersen on 3/1/15.
//  Copyright (c) 2015 Mikkel Vester Petersen. All rights reserved.
//

#import "ChartView.h"

@implementation ChartView

@synthesize discountPercentage = _discountPercentage;
@synthesize discountPrice = _discountPrice;
@synthesize originalPrice = _originalPrice;
@synthesize savings = _savings;

- (id)initWithFrame:(CGRect)frame
{
    NSLog(@"initWithFrame");
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawBars:context];
    [self drawLabels];
}

- (void)drawBars:(CGContextRef)context {
    CGContextSetLineWidth(context, 1.0);
    
    // Original price bar
    CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 0.5);
    CGContextAddRect(context, CGRectMake(0.0,
                                         0.0,
                                         self.bounds.size.width/2-5,
                                         self.bounds.size.height
                                         ));
    CGContextDrawPath(context, kCGPathFillStroke);
    
    // Saved amount bar
    CGContextSetRGBFillColor(context, 0.0, 0.5, 0.0, 0.5);
    CGContextAddRect(context, CGRectMake(self.bounds.size.width/2+5,
                                         0,
                                         self.bounds.size.width/2-5,
                                         self.bounds.size.height*_discountPercentage
                                         ));
    CGContextDrawPath(context, kCGPathFillStroke);
    // Discount price bar
    CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 0.9);
    CGContextAddRect(context, CGRectMake(self.bounds.size.width/2+5,
                                         self.bounds.size.height*_discountPercentage,
                                         self.bounds.size.width/2-5,
                                         self.bounds.size.height*(1-_discountPercentage
                                                                  )));
    CGContextDrawPath(context, kCGPathFillStroke);
}

-(void)drawLabels {
    UILabel *lblOriginalPriceWithTax = [[UILabel alloc]initWithFrame:CGRectMake(0,
                                                                                0,
                                                                                self.bounds.size.width/2-5,
                                                                                self.bounds.size.height)
                                                                                ];
    [lblOriginalPriceWithTax setBackgroundColor:[UIColor clearColor]];
    [lblOriginalPriceWithTax setNumberOfLines:3];
    [lblOriginalPriceWithTax setText:_originalPrice];
    [lblOriginalPriceWithTax setTextAlignment: NSTextAlignmentCenter];
    [self addSubview:lblOriginalPriceWithTax];
    
    UILabel *lblSavings = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width/2+5,
                                                                   0,
                                                                   self.bounds.size.width/2-5,
                                                                   self.bounds.size.height*_discountPercentage
                                                                   )];
    [lblSavings setBackgroundColor:[UIColor clearColor]];
    [lblSavings setNumberOfLines:2];
    [lblSavings setText:_savings];
    [lblSavings setTextAlignment: NSTextAlignmentCenter];
    [self addSubview:lblSavings];
    
    UILabel *lblDiscountPriceWithTax = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width/2+5,
                                                                                self.bounds.size.height*_discountPercentage,
                                                                                self.bounds.size.width/2-5,
                                                                                self.bounds.size.height*(1-_discountPercentage)
                                                                                )];
    [lblDiscountPriceWithTax setBackgroundColor:[UIColor clearColor]];
    [lblDiscountPriceWithTax setNumberOfLines:2];
    [lblDiscountPriceWithTax setText:_discountPrice];
    [lblDiscountPriceWithTax setTextAlignment: NSTextAlignmentCenter];
    [self addSubview:lblDiscountPriceWithTax];
    
}

@end
