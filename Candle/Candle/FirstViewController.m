//
//  FirstViewController.m
//  Candle
//
//  Created by Peter Sulik on 10/30/12.
//  Copyright (c) 2012 Peter Sulik. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize candleNameTextBox, rozvrhLabel, tabulkaRozvrh;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)vypisRozvrh:(id)sender
{
    NSArray * predmety = [NSArray arrayWithObjects: @"telesna", @"matematika", @"pocitace", nil];  
  //  NSMutableArray *array = [NSMutableArray arrayWithObjects: @"one", @"two", @"three", @"four", nil];
    
     NSString *tempPredmety;
    
    for (NSString * str in predmety) {
        tempPredmety = [NSString stringWithFormat:@"%@, %@", tempPredmety, str];
      //  tempPredmety = [tempPredmety stringByAppendingString:str];
    }
    rozvrhLabel.text = tempPredmety;

}


- (void)backgroundTouchedHideKeyboard:(id)sender
{
    [tempTextBox resignFirstResponder];
}






- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.candleNameTextBox = nil;
    self.rozvrhLabel = nil;
}

@end