//
//  ChartView.h
//  Discount
//
//  Created by Mikkel Petersen on 3/1/15.
//  Copyright (c) 2015 Mikkel Vester Petersen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartView : UIView

@property float  discountPercentage;
@property NSString* originalPrice;
@property NSString* discountPrice;
@property NSString* savings;

@end
