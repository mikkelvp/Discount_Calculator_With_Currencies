//
//  CurrencyViewController.m
//  Discount
//
//  Created by Mikkel Petersen on 4/8/15.
//  Copyright (c) 2015 Mikkel Vester Petersen. All rights reserved.
//

#import "CurrencyViewController.h"
#import "Currency.h"
#import "ExchangeRate.h"
#import "ViewController.h"
#import "Settings.h"

NSArray *_pickerData;
NSInteger _homePickerValue;
NSInteger _foreignPickerValue;
NSMutableData *_responseData;
ExchangeRate *_rate;

@implementation CurrencyViewController

-(void)viewDidLoad
{
    _pickerData = [NSArray arrayWithObjects:@"Brazilian Real", @"British Pound", @"Canadian Dollar", @"Chinese Yuan", @"Danish Kroner", @"Euro", @"Indian Rupee", @"Japanese Yen", @"Mexican Peso", @"Russian Ruble", @"US Dollar", nil];

    self.homePicker.dataSource = self;
    self.homePicker.delegate = self;
    self.foreignPicker.dataSource = self;
    self.foreignPicker.delegate = self;
}

// PickerView methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row
           forComponent:(NSInteger)component
{
    return _pickerData[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == self.homePicker) {
        _homePickerValue = row;
    }
    else if (pickerView == self.foreignPicker) {
        _foreignPickerValue = row;
    }
}

// Button eventhandler
- (IBAction)setBtnClicked:(id)sender {
    [self.indicator startAnimating];
    
    NSArray *selectorStrings = @[@"theBrazilianReal",
                     @"theBritishPound",
                     @"theCanadianDollar",
                     @"theChineseYuan",
                     @"theDanishKroner",
                     @"theEuro",
                     @"theIndianRupee",
                     @"theJapaneseYen",
                     @"theMexicanPeso",
                     @"theRussianRuble",
                     @"theUSDollar"];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    
    // create selectors
    SEL homeSelector = NSSelectorFromString(selectorStrings[_homePickerValue]);
    SEL foreignSelector = NSSelectorFromString(selectorStrings[_foreignPickerValue]);
    
    // perform selectors on Currency class
    Currency *home = [[Currency class] performSelector:homeSelector];
    Currency *foreign = [[Currency class] performSelector:foreignSelector];
    
#pragma clang diagnostic pop

    // create exchangerate object from file, create new object if no file exists
    if (![self readExchangeRateFileWithHomeCurrency:home foreign:foreign]) {
        _rate = [[ExchangeRate alloc] initWithSrcCurrency:home destination:foreign];
    }
    
    // update rate
    [_rate updateWithDelegate:self];
    Settings *settings = [Settings sharedSingletonInstance];
    settings.currentExchangeRate = _rate;
}

-(BOOL)writeExchangeRateToFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName = [NSString stringWithFormat:@"%@%@.%@", _rate.srcCurrency.code, _rate.dstCurrency.code, [ExchangeRate class]];
    NSString *library = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]; // Library dir
    NSString *privateDocuments = [library stringByAppendingPathComponent:@"/Private Documents"];
    NSString *appdir = [privateDocuments stringByAppendingPathComponent:@"/DiscountCalcWithCurrencies"];
    NSError *err;

    // Check if path exist, create if not
    if (![fileManager fileExistsAtPath:privateDocuments]) {
        NSLog(@"Private Documents dir does not exist");
        if ([fileManager createDirectoryAtPath:privateDocuments withIntermediateDirectories:YES attributes:nil error:&err]) {
            NSLog(@"Private Documents dir created");
            
            if (![fileManager fileExistsAtPath:appdir]) {
                if ([fileManager createDirectoryAtPath:appdir withIntermediateDirectories:YES attributes:nil error:&err]) {
                    NSLog(@"appdir created: %@", appdir);
                }
                else {
                    NSLog(@"appdir not created. err: %@", err);
                }
            }
        }
        else {
            NSLog(@"Private Documents dir not created");
            NSLog(@"err: %@", err);
        }
    }
    
    return [NSKeyedArchiver archiveRootObject:_rate toFile:[appdir stringByAppendingPathComponent:fileName]];
}

-(BOOL)readExchangeRateFileWithHomeCurrency:(Currency*)home
                                  foreign:(Currency*)foreign
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName = [NSString stringWithFormat:@"%@%@.%@", home.code, foreign.code, [ExchangeRate class]];
    NSString *library = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]; // Library dir
    NSString *filePath = [[library stringByAppendingPathComponent:@"Private Documents/DiscountCalcWithCurrencies"] stringByAppendingPathComponent:fileName];
    
    BOOL fileExists = [fileManager fileExistsAtPath:filePath];
    if (fileExists) {
        _rate = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        NSLog(@"File read. rate: %@-%@", _rate.srcCurrency.code, _rate.dstCurrency.code);
        [self.indicator stopAnimating];
        [self performSegueWithIdentifier:@"mainView" sender:self];
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)isiOS8OrAbove {
    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"8.0"
                                                                       options: NSNumericSearch];
    return (order == NSOrderedSame || order == NSOrderedDescending);
}

// NSURLConnectionDataDelegate Methods
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //Response recieved
    _responseData = [[NSMutableData alloc] init];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //Data recieved
    [_responseData appendData:data];
}

-(NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return nil;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //request is complete
    NSError *error = nil;
    
    id unknownObject = [NSJSONSerialization
                        JSONObjectWithData: _responseData
                        options: 0
                        error: &error];
    
    NSDictionary *exchangeRatesDictionary;
    
    if (!error) {
        NSLog(@"Loaded JSON Data Successfully");
        
        _rate.lastFetchedOn = [NSDate date];
        
        if ([unknownObject isKindOfClass: [NSDictionary class]]) {
            exchangeRatesDictionary = unknownObject;
            NSDictionary *result = [[[exchangeRatesDictionary valueForKey: @"query"] valueForKey:@"results"] valueForKey: @"rate"];
            _rate.rate = [NSNumber numberWithFloat: [[result objectForKey: @"Rate"] floatValue]];
            _rate.lastFetchedOn = [NSDate date];
            NSLog(@"%@", _rate.rate);
            if ([self writeExchangeRateToFile]) {
                NSLog(@"Wrote to file");
            }
            else {
                NSLog(@"Write to file failed");
            }
        }
        else {
            exchangeRatesDictionary = nil;
        }
    }
    [self.indicator stopAnimating];
    [self performSegueWithIdentifier:@"mainView" sender:self];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Request failed
    [self.indicator stopAnimating];
    // Display alert
    NSString* title = @"Request failed";
    NSString* msg = [error.userInfo valueForKey:@"NSLocalizedDescription"];
    if ([self isiOS8OrAbove]) {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title
                                                             message:msg
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles: nil];
        [alertView show];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
