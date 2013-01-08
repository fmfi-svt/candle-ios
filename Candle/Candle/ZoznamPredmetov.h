//
//  ZoznamPredmetov.h
//  Candle
//
//  Created by Pejko Salik on 11/25/12.
//  Copyright (c) 2012 Peter Sulik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface ZoznamPredmetov : NSObject {
    sqlite3 *db;
  //  NSMutableArray *predmety;
}


- (NSMutableArray *) getLessons;

-(IBAction)setLessons:(id)sender;
-(IBAction)addLesson:(NSString *)newLesson;

-(IBAction)vypisPredmety:(UILabel *)rozvrhLabel;

-(IBAction)vypisPredmetyNaDen:first:(UILabel*)rozvrhLabel second:(NSNumber*)den;
@end
