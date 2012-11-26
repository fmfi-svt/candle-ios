//
//  ZoznamPredmetov.m
//  Candle
//
//  Created by Pejko Salik on 11/25/12.
//  Copyright (c) 2012 Peter Sulik. All rights reserved.
//

#import "ZoznamPredmetov.h"

@implementation ZoznamPredmetov

-(IBAction)setLessons:(id)sender
{
    predmety = [NSMutableArray arrayWithObjects: @"telesna", @"matematika", @"pocitace", nil];
}
-(IBAction)addLesson:(NSString*)newLesson
{
    [predmety addObject:newLesson];
}



-(IBAction)vypisPredmety:(UILabel *)rozvrhLabel;
{
    
    //  NSMutableArray *array = [NSMutableArray arrayWithObjects: @"one", @"two", @"three", @"four", nil];
    
    NSString *tempPredmety;
    
    for (NSString *str in predmety) {
        tempPredmety = [NSString stringWithFormat:@"%@, %@", tempPredmety, str];       
    }
    rozvrhLabel.text = tempPredmety;
    
}



@end