//
//  ZoznamPredmetov.h
//  Candle
//
//  Created by Pejko Salik on 11/25/12.
//  Copyright (c) 2012 Peter Sulik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZoznamPredmetov : NSObject {
    NSMutableArray *predmety;
}
-(IBAction)setLessons:(id)sender;
-(IBAction)addLesson:(NSString*)newLesson;

-(IBAction)vypisPredmety:(UILabel *)sender;

@end
