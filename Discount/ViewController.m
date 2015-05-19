//
//  ViewController.m
//  Discount
//
//  Created by Mikkel Petersen on 2/19/15.
//  Copyright (c) 2015 Mikkel Vester Petersen. All rights reserved.
//

#import "ViewController.h"
#import "Item.h"
#import "UITextField+NextTextField.h"
#import "ExchangeRate.h"
#import "Settings.h"

Item* item;
ExchangeRate *rate;
Settings* settings;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtPrice;
@property (weak, nonatomic) IBOutlet UITextField *txtDollarsOff;
@property (weak, nonatomic) IBOutlet UITextField *txtDiscount;
@property (weak, nonatomic) IBOutlet UITextField *txtAddDisc;
@property (weak, nonatomic) IBOutlet UITextField *txtTax;
@property (weak, nonatomic) IBOutlet UILabel *lblOriginalPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblDiscountPrice;
@property NSString* decimalSeparator;
@property (weak, nonatomic) UITextField *txtActive;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;

@end

@implementation ViewController

- (IBAction)CalculateButtonIsPressed:(id)sender {
    
    
    // set item properties with user input
    item.price = [NSDecimalNumber decimalNumberWithString:
                  [self.txtPrice text]];
    item.dollarsOff = [NSDecimalNumber decimalNumberWithString:
                       [self.txtDollarsOff text]];
    item.discount = [NSDecimalNumber decimalNumberWithString:
                     [self.txtDiscount text]];
    item.addDisc = [NSDecimalNumber decimalNumberWithString:
                    [self.txtAddDisc text]];
    item.tax = [NSDecimalNumber decimalNumberWithString:
                [self.txtTax text]];
    
    
    // Validate user input and display results.
    if (item.price.doubleValue > 0 && item.price != [NSDecimalNumber notANumber]) {
        if (item.price.doubleValue > item.dollarsOff.doubleValue || item.dollarsOff == [NSDecimalNumber notANumber]) {
            if (item.discount.doubleValue <= 100.0 || item.discount == [NSDecimalNumber notANumber]) {
                if (item.addDisc.doubleValue <= 100.0 || item.addDisc == [NSDecimalNumber notANumber]) {
                    [self.lblDiscountPrice setText:[NSString stringWithFormat:@"Discount price:\nHome: %@\nForeign: %@",
                                                    [rate.srcCurrency.formatter stringFromNumber:[item calcDiscountPrice]],
                                                    [rate.dstCurrency.formatter stringFromNumber:[[item discountPriceWithTax] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithDecimal:rate.rate.decimalValue]]] ]];
                    [self.lblDiscountPrice setTextColor:[UIColor blackColor]];
                    [self.lblOriginalPrice setText:[NSString stringWithFormat:@"Original price: %@\nForeign: %@", [rate.srcCurrency.formatter stringFromNumber:[item calcOriginalPrice]], [rate.dstCurrency.formatter stringFromNumber:[[item originalPriceWithTax] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithDecimal:rate.rate.decimalValue]]]  ]];
                }
                else {
                    [self setDiscountLabelTextWithRedColor:@"Additional discount can max be 100%"];
                }
            }
            else {
                [self setDiscountLabelTextWithRedColor:@"Discount can max be 100%"];
            }
        }
        else {
            [self setDiscountLabelTextWithRedColor:@"Dollars off can not be higher than the price"];
        }
    }
    else {
        [self setDiscountLabelTextWithRedColor:@"Price must be above 0"];
    }
    
    NSLog(@"ViewController rate: %@", rate.rate);

}

// Show error message
- (void)setDiscountLabelTextWithRedColor:(NSString*)aString {
    [self.lblDiscountPrice setText:aString];
    [self.lblDiscountPrice setTextColor:[UIColor redColor]];
}

// Format textfield as currency
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)aString {
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setCurrencyCode:@"USD"];
    
    // Update string
    NSMutableString* currentString = [NSMutableString stringWithString:textField.text];
    [currentString replaceCharactersInRange:range withString:aString];
    // Remove decimal separator
    [currentString replaceOccurrencesOfString:numberFormatter.decimalSeparator withString:@""
                                      options:NSLiteralSearch range:NSMakeRange(0, currentString.length)];
    // Create new string
    int value = [currentString intValue];
    NSString* format = [NSString stringWithFormat:@"%%.%df", 2];
    
    // Update textfield
    [textField setText:[NSString stringWithFormat:format, value/100.0]];
    return NO;
}

// Dismiss keyboard on touch outside of keyboard
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event	{
    [[self view] endEditing:YES];
}

// Dismiss keyboard on return button press
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

// Switch to next textfield
- (void)nextClicked: (UIBarButtonItem*) sender
{
    UITextField* next = _txtActive.nextTextField;
    if (next) {
        [next becomeFirstResponder];
    }
}

// Switch to previous textfield
- (void)prevClicked: (UIBarButtonItem*) sender
{
    UITextField* prev = _txtActive.prevTextField;
    if (prev) {
        [prev becomeFirstResponder];
    }
}

- (void) doneClicked: (UIBarButtonItem*) sender
{
    [_txtActive resignFirstResponder];
}

-(void) zeroClicked: (UIBarButtonItem*) sender
{
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setCurrencyCode:@"USD"];
    
    // Add two zero's to textfield
    [_txtActive replaceRange:_txtActive.selectedTextRange withText:@"00"];
    
    NSMutableString* currentString = [NSMutableString stringWithString:[_txtActive text]];
    
    // Remove decimal separator
    [currentString replaceOccurrencesOfString:numberFormatter.decimalSeparator withString:@"" options:NSLiteralSearch range:NSMakeRange(0, currentString.length)];
    
    // Create new string
    int value = [currentString intValue];
    NSString* format = [NSString stringWithFormat:@"%%.%df", 2];
    
    // Update textfield
    [_txtActive setText:[NSString stringWithFormat:format, value/100.0]];
}

// Add toolbar to keyboard. Sample code used.
- (BOOL)textFieldShouldBeginEditing: (UITextField *) textField
{
    _txtActive = textField;
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar sizeToFit];
    
    UIBarButtonItem *prevButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"Previous"
                                   style: UIBarButtonItemStyleDone
                                   target: self
                                   action:@selector(prevClicked:)];
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"Next"
                                   style: UIBarButtonItemStyleDone
                                   target: self
                                   action:@selector(nextClicked:)];
    
    UIBarButtonItem *zeroButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"00"
                                   style: UIBarButtonItemStyleDone
                                   target: self
                                   action:@selector(zeroClicked:)];
    
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                   target: self
                                   action: nil];
    
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                  target: self
                                  action: @selector(doneClicked:)];
    
    NSArray* itemsArray = @[prevButton, nextButton, zeroButton, flexButton, doneButton];
    
    [toolbar setItems: itemsArray];
    
    [textField setInputAccessoryView: toolbar];
    
    return YES;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    item = [Item sharedSingletonInstance];
    
    // Load item values
    if (item.price.doubleValue > 0.00 && item.price != [NSDecimalNumber notANumber]) {
        [_txtPrice setText:[NSString stringWithFormat:@"%@", item.price]];
    }
    if (item.discount.doubleValue > 0.00 && item.discount != [NSDecimalNumber notANumber]) {
        [_txtDiscount setText:[NSString stringWithFormat:@"%@", item.discount]];
    }
    if (item.addDisc.doubleValue > 0.00 && item.addDisc != [NSDecimalNumber notANumber]) {
        [_txtAddDisc setText:[NSString stringWithFormat:@"%@", item.addDisc]];
    }
    if (item.dollarsOff.doubleValue > 0.00 && item.dollarsOff != [NSDecimalNumber notANumber]) {
        [_txtDollarsOff setText:[NSString stringWithFormat:@"%@", item.dollarsOff]];
    }
    if (item.tax.doubleValue > 0.00 && item.tax != [NSDecimalNumber notANumber]) {
        [_txtTax setText:[NSString stringWithFormat:@"%@", item.tax]];
    }
    
    // Set textfield next and previous textfields
    _txtPrice.nextTextField = _txtDollarsOff;
    _txtDollarsOff.nextTextField = _txtDiscount;
    _txtDiscount.nextTextField = _txtAddDisc;
    _txtAddDisc.nextTextField = _txtTax;
    _txtTax.nextTextField = _txtPrice;
    
    _txtPrice.prevTextField = _txtTax;
    _txtDollarsOff.prevTextField = _txtPrice;
    _txtDiscount.prevTextField = _txtDollarsOff;
    _txtAddDisc.prevTextField = _txtDiscount;
    _txtTax.prevTextField = _txtAddDisc;
    
    settings = [Settings sharedSingletonInstance];
    if (!rate) {
        [self.lblStatus setText:@"No exchange rate found. Using USD."];
        settings.currentExchangeRate = [[ExchangeRate alloc] initWithSrcCurrency:[Currency theUSDollar] destination:[Currency theUSDollar]];
        settings.currentExchangeRate.rate = [NSNumber numberWithInt:1];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    
    rate = settings.currentExchangeRate;

    // Hide status label if a exchange rate is present
    if (rate.rate.integerValue > -1) {
        [self.lblStatus setHidden:YES];
        [self.lblPrice setText:[NSString stringWithFormat:@"Price %@", rate.srcCurrency.symbol]];
    }
    
}

- (BOOL)isiOS8OrAbove {
    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"8.0"
                                                                       options: NSNumericSearch];
    return (order == NSOrderedSame || order == NSOrderedDescending);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
