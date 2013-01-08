//
//  ZoznamPredmetov.m
//  Candle
//
//  Created by Pejko Salik on 11/25/12.
//  Copyright (c) 2012 Peter Sulik. All rights reserved.
//

#import "ZoznamPredmetov.h"
#import "Predmet.h"

@implementation ZoznamPredmetov

- (NSMutableArray *) getLessons{
    NSMutableArray *Zoznam = [[NSMutableArray alloc] init];
    @try {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"IOSDB.sqlite"];
        BOOL success = [fileMgr fileExistsAtPath:dbPath];
        if(!success)
        {
            NSLog(@"Cannot locate database file '%@'.", dbPath);
        }
        if(!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        const char *sql = "SELECT id, name, room, day, start, length FROM  rozvrh";
        sqlite3_stmt *sqlStatement;
        if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
        
        //
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
            Predmet *predm = [[Predmet alloc]init];
            predm.predmetId = [NSNumber numberWithInt: sqlite3_column_int(sqlStatement, 0)];
            predm.name = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)];
            predm.room = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,2)];
            predm.day = [NSNumber numberWithInt: sqlite3_column_int(sqlStatement, 3)];
            predm.start = [NSNumber numberWithInt: sqlite3_column_int(sqlStatement, 4)];
            predm.classLength = [NSNumber numberWithInt: sqlite3_column_int(sqlStatement,5)];              
            
            [Zoznam addObject:predm];
        //    [predmety addObject:predm];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return Zoznam;
    }
    
    
}

/*

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

-(IBAction)vypisPredmetyNaDen:first:(UILabel*)rozvrhLabel second:(NSNumber*)den;
{
    NSString *tempPredmety;
    for (NSString *str in predmety) {
        tempPredmety = [NSString stringWithFormat:@"%@, %@", tempPredmety, str];
    }
    rozvrhLabel.text = tempPredmety;
}
*/




@end