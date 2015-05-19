//
//  CurrencyViewController.h
//  Discount
//
//  Created by Mikkel Petersen on 4/8/15.
//  Copyright (c) 2015 Mikkel Vester Petersen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrencyViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, NSURLConnectionDataDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIPickerView *homePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *foreignPicker;
@end
