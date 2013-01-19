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

-(NSMutableArray *) getDataFromCSV{
    self.username = @"sulo";
    
    //stiahnut candle rozvrh
    NSString *stringURL = [NSString stringWithFormat: @"https://candle.fmph.uniba.sk/rozvrh/%@.csv" ,self.username];    
    
    NSURL  *url = [NSURL URLWithString:stringURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    NSString *string = [NSString stringWithUTF8String:[urlData bytes]];
    //DLog(@"%@",string);
    NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    
    NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"candle.csv"];
    if ( urlData )
    {

        [urlData writeToFile:filePath atomically:YES];
    }
    
    
    //jednoduchy parser
      NSError *error;
    //filePath @"candle.csv"
    
    NSString *dataStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (dataStr) {
        //DLog(@"%@", dataStr);
    } else {
        DLog(@"%@",[error localizedDescription]);
              }
    
    NSArray *poleItemov = [dataStr componentsSeparatedByString: @","];
//    DLog(@"%@",poleItemov);
    
    int i=0;
    NSMutableArray *pole = [[NSMutableArray alloc] init];
    
    for (NSString *item in poleItemov) {
        if (i>8) {
            Predmet *predm = [[Predmet alloc] init];
            int cislo = 1;
            int zostatok = i % 9;
//            DLog(@"zostatok: %d", zostatok);
            switch (zostatok) {
                case 7:
                    predm.name = [poleItemov objectAtIndex:i];
//                    DLog(@"Predmet name: %@", predm.name);
                    [pole addObject:predm];
                    //   DLog(@"%@ ", predm.name);
                    break;
                case 5:
                    predm.room = [poleItemov objectAtIndex:i];
                    break;
                case 1:
                    // ?????preco mi nepinda, ze potrebuje zkonvertovat z NSSTRING do NSNumber?
                    predm.day = [poleItemov objectAtIndex:i];
                    break;
                case 2:
                    predm.start = [poleItemov objectAtIndex:i];
                    break;
                case 4:
                    
                    cislo = (int)[[poleItemov objectAtIndex:i] characterAtIndex:0]-48;
                    predm.classLength = [NSNumber numberWithInt:cislo];
                    
                    break;
                default:
                    break;
            }
        }
        i++;
    }
//    DLog(@"POLE %@",pole);
    
    return pole;
}

- (IBAction) setLocalDB:(NSArray *)poleNaInsert;
{
    sqlite3_stmt *insert_statement;
    
    // Prepare the insert statement
    const char*sql = "INSERT INTO rozvrh (name, room, day, start, length) VALUES(?,?,?,?,?)";
    sqlite3_prepare_v2(db, sql, -1, &insert_statement, NULL);
    
    // Iterate over an array of dictionaries
    for (Predmet *predm in poleNaInsert) {
        
        // Bind variables - assumed to all be integers
        sqlite3_bind_text(insert_statement, 1, [predm.name UTF8String],-1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert_statement, 2, [predm.room UTF8String],-1, SQLITE_TRANSIENT);
        sqlite3_bind_int(insert_statement, 3, [predm.day intValue]);
        sqlite3_bind_int(insert_statement, 4, [predm.start intValue]);
        sqlite3_bind_int(insert_statement, 5, [predm.classLength intValue]);

        // Execute the insert
        if (sqlite3_step(insert_statement) != SQLITE_DONE) {
            DLog(@"Insert failed: %s", sqlite3_errmsg(db));
        }
        
        // Reset the statement
        sqlite3_reset(insert_statement);
    }
    
    // release the statement
    sqlite3_finalize(insert_statement);
  
    
}





- (NSMutableArray *) getLessonsFromDB{
    NSMutableArray *Zoznam = [[NSMutableArray alloc] init];
    @try {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"candle.sqlite"];
        BOOL success = [fileMgr fileExistsAtPath:dbPath];
        if(!success)
        {
            DLog(@"Cannot locate database file '%@'.", dbPath);
        }
        if(!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK))
        {
            DLog(@"An error has occured.");
        }
        const char *sql = "SELECT id, name, room, day, start, length FROM  rozvrh";
        sqlite3_stmt *sqlStatement;
        if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            DLog(@"Problem with prepare statement");
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
        DLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return Zoznam;
    }
    
    
}



- (IBAction) nastavUsername:(UITextField *)UIUserNameTextField;
{
    self.username = UIUserNameTextField.text;
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