//
//  FirstViewController.m
//  Candle
//
//  Created by Pejko Salik on 10/30/12.
//  Copyright (c) 2012 Pejko Salik. All rights reserved.
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









- (void)degreeConvert:(id)sender
{
    double fahren = [tempTextBox.text doubleValue];
    double celsius = (fahren - 32) / 1.8;
    
    [tempTextBox resignFirstResponder];
    
    NSString *convertResult = [[NSString alloc] initWithFormat: @"Celsius: %f", celsius];
    calcResult.text = convertResult;
}

- (void)backgroundTouchedHideKeyboard:(id)sender
{
    [tempTextBox resignFirstResponder];
}

- (void)writeRozvrh:(id)sender
{

}





- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.candleNameTextBox = nil;
    self.calcResult = nil;
}

@end