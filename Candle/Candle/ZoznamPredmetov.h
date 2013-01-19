//
//  ZoznamPredmetov.h
//  Candle
//
//  Created by Pejko Salik on 11/25/12.
//  Copyright (c) 2012 Peter Sulik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "NSString+ParsingExtensions.h"
@interface ZoznamPredmetov : NSObject {
    sqlite3 *db;
  //  NSMutableArray *predmety;
}

@property(readwrite,retain) NSString *username;


- (NSMutableArray *) getLessonsFromDB;
- (NSMutableArray *) getDataFromCSV;
- (IBAction) setLocalDB:(NSArray *)poleNaInsert;
- (IBAction) nastavUsername:(UITextField *)UIUserNameTextField;
//-(IBAction)setLessons:(id)sender;
//-(IBAction)addLesson:(NSString *)newLesson;

//-(IBAction)vypisPredmety:(UILabel *)rozvrhLabel;

//-(IBAction)vypisPredmetyNaDen:first:(UILabel*)rozvrhLabel second:(NSNumber*)den;
@end
