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

+ (id) zoznamPredmetovWithDefaultURLandNick: (NSString *)nick AndWithError: (NSError **) error{
    
    ZoznamPredmetov *zp = [[self alloc] init];
    if ([ZoznamPredmetov checkConnection]) {
        if([ZoznamPredmetov downloadCandleCSV:nick]){
            if([zp getDataFromCSV:[ZoznamPredmetov downloadedCSVFilePath]]){
                return zp;
            } else {
                NSDictionary* errorDictionary = @{NSLocalizedDescriptionKey : @"Nepodarilo sa nacitat zo suboru."};
                if (error != NULL) {
                    *error = [NSError errorWithDomain:@"error" code:100 userInfo:errorDictionary];
                }                
            }
        } else {
            NSDictionary* errorDictionary = @{NSLocalizedDescriptionKey : @"Nepodarilo sa stiahnut rozvrh."};
            if (error != NULL) {
                *error = [NSError errorWithDomain:@"error" code:100 userInfo:errorDictionary];
            }
        }        
    } else {
        NSDictionary* errorDictionary = @{NSLocalizedDescriptionKey : @"Nie si pripojeny na net"};
        if (error != NULL) {
            *error = [NSError errorWithDomain:@"error" code:100 userInfo:errorDictionary];
        }
    }
    return nil;
}

+(BOOL) checkConnection{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if(internetStatus == NotReachable) {
        return NO;
    }
    return YES;
}

+(BOOL) downloadCandleCSV:(NSString *)nazovRozvrhu{
    
    NSString *stringURL = [NSString stringWithFormat: @"https://candle.fmph.uniba.sk/rozvrh/%@.csv" ,nazovRozvrhu];
    NSURL  *url = [NSURL URLWithString:stringURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if ( urlData )
    {
        [urlData writeToFile:[ZoznamPredmetov downloadedCSVFilePath] atomically:YES];
        return YES;
    }
    return NO;
}

+ (NSString *) downloadedCSVFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    return [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"candle.csv"];
}


-(BOOL) getDataFromCSV:(NSString *)filePath{
    NSError *error;
    NSString *dataStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (dataStr) {        
    } else {
        DLog(@"%@",[error localizedDescription]);
        return NO;
    }
    
    NSMutableArray *poleItemov = [[dataStr csvRows] mutableCopy];    
    [poleItemov removeObjectAtIndex:0];        
    self.predmety = [[NSMutableArray alloc] init];    
    
    for (NSArray *item in poleItemov)
    {
        Predmet *predm = [[Predmet alloc] init];
        NSString* den = [item objectAtIndex:0];
        NSArray *dniTyzdna = @[@"Po", @"Ut", @"Str", @"St", @"Pi"];
        int cislo = [dniTyzdna indexOfObject: den];        
        
        predm.day = [NSNumber numberWithInt: cislo];
        predm.start = [item objectAtIndex:1];
        predm.room = [item objectAtIndex:4];
        predm.name = [item objectAtIndex:6];
        cislo = (int)[[item objectAtIndex:3] characterAtIndex:0]-48;
        predm.duration = [NSNumber numberWithInt:cislo];
        
        [self.predmety addObject:predm];
    }
    DLog(@"POLE %@",self.predmety);
    
    return YES;
}


- (NSMutableArray *) getLessonsForDay:(int)den{
    NSMutableArray *pole = [[NSMutableArray alloc] init];
    for (Predmet *predm in _predmety) {
        if([predm.day integerValue]==den){
            [pole addObject:predm];
        }
    }
    return pole;
    
}

- (void) nastavUsername:(UITextField *)UIUserNameTextField{
    self.username = UIUserNameTextField.text;
}

- (void) setLocalDbFromParsedXML:(NSArray *)poleNaInsert;
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
                sqlite3_bind_int(insert_statement, 5, [predm.duration intValue]);
        
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
                        predm.start = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,4)];
                        predm.duration = [NSNumber numberWithInt: sqlite3_column_int(sqlStatement,5)];
                        
                        [Zoznam addObject:predm];
                        [_predmety addObject:predm];
                    }
            }
        @catch (NSException *exception) {
                DLog(@"An exception occured: %@", [exception reason]);
            }
        @finally {
                return Zoznam;
            }
    
}







@end
