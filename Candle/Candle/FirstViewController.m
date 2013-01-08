//
//  FirstViewController.m
//  Candle
//
//  Created by Peter Sulik on 10/30/12.
//  Copyright (c) 2012 Peter Sulik. All rights reserved.
//

#import "FirstViewController.h"
#import "Predmet.h"
#import "ZoznamPredmetov.h"



@interface FirstViewController ()
@end


@implementation FirstViewController

@synthesize polePredmetov,UInazovPredmetu,UImiestnostPredmetu,UIzaciatokPredmetu;
@synthesize candleNameTextBox, rozvrhLabel, tabulkaRozvrh;



- (void)viewDidLoad
{
    
    ZoznamPredmetov * dbPredmetov =[[ZoznamPredmetov alloc] init];
    self.polePredmetov = [dbPredmetov getLessons];
    [self.UInazovPredmetu setText:((Predmet *) [self.polePredmetov objectAtIndex:0]).name];
    [self.UImiestnostPredmetu setText:((Predmet *) [self.polePredmetov objectAtIndex:0]).room];
  
    
    [self.UIzaciatokPredmetu setText:( [((Predmet *) [self.polePredmetov objectAtIndex:0]).start stringValue] )];
    
    
    
    
    
    
    [super viewDidLoad];
    
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)vypisPredmet:(id)sender
{
    static NSInteger currentIndex = 0;
    if (++currentIndex == [self.polePredmetov count]) {
        currentIndex=0;
    }else{
        Predmet *predmet = (Predmet *) [self.polePredmetov objectAtIndex: currentIndex];
        [self.UInazovPredmetu setText:predmet.name];
        [self.UImiestnostPredmetu setText:predmet.room];
        [self.UIzaciatokPredmetu setText:[predmet.start stringValue]];
}
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
    self.polePredmetov =nil;
    self.UInazovPredmetu = nil;
    self.UImiestnostPredmetu = nil;
    self.UIzaciatokPredmetu = nil;
    self.candleNameTextBox = nil;
    self.rozvrhLabel = nil;
}

@end