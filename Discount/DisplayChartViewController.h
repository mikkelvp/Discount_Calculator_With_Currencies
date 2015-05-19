//
//  DisplayChartViewController.h
//  Discount
//
//  Created by Mikkel Petersen on 2/19/15.
//  Copyright (c) 2015 Mikkel Vester Petersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
#import "ChartView.h"

@interface DisplayChartViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblTest;
@property Item *item;
@property (weak, nonatomic) IBOutlet ChartView *Chart;

@end
