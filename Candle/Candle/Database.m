//
//  Database.m
//  Candle
//
//  Created by Pejko Salik on 6/21/13.
//  Copyright (c) 2013 Peter Sulik. All rights reserved.
//

#import "Database.h"
static Database *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation Database

static NSString *DATABASE_NAME = @"rozvrh3";
static int *DATABASE_VERSION = 1;

// tabulka pre hodiny
// (`id`, `den`, `zaciatok`, `koniec`, `miestnost`, `trvanie`, `predmet`,
// `ucitelia`, `kruzky`, `typ`, `kod_predmetu`,`kredity`, `rozsah`,
// `kapacita_mistnosti`, `typ_miestnosti`) SELECT '328'
static  NSString *TB_HODINY_NAME = @"hodiny";
static  NSString *COLUMN_HODINY_ID = @"id";
static  NSString *COLUMN_HODINY_DEN = @"den";
static  NSString *COLUMN_HODINY_ZACIATOK = @"zaciatok";
static  NSString *COLUMN_HODINY_KONIEC = @"koniec";
static  NSString *COLUMN_HODINY_MIESTNOST = @"miestnost";
static  NSString *COLUMN_HODINY_TRVANIE = @"trvanie";
static  NSString *COLUMN_HODINY_PREDMET = @"predmet";
static  NSString *COLUMN_HODINY_UCITELIA = @"ucitelia";
static  NSString *COLUMN_HODINY_KRUZKY = @"kruzky";
static  NSString *COLUMN_HODINY_TYP = @"typ";
static  NSString *COLUMN_HODINY_KOD_PREDMETU = @"kod_predmetu";
static  NSString *COLUMN_HODINY_KREDITY = @"kredity";
static  NSString *COLUMN_HODINY_ROZSAH = @"rozsah";
static  NSString *COLUMN_HODINY_KAPACITA_MIESTNOSTI = @"kapacita_mistnosti";
static  NSString *COLUMN_HODINY_TYP_MIESTRNOSTI = @"typ_miestnosti";

// tabulka pre id ucitelov, ktori ucia danu hodinu
// (`idHodiny`, `idUcitela`, `katedra`, `meno`, `oddelenie`, `priezvisko`)
static  NSString *TB_HODUCITEL = @"hoducitel";
static  NSString *COLUMN_HODUCITEL_IDHODINY = @"idHodiny";
static  NSString *COLUMN_HODUCITEL_IDUCITELA = @"idUcitela";
static  NSString *COLUMN_HODUCITEL_PRIEZVISKO = @"priezvisko";
static  NSString *COLUMN_HODUCITEL_MENO = @"meno";
static  NSString *COLUMN_HODUCITEL_KATEDRA = @"katedra";
static  NSString *COLUMN_HODUCITEL_ODDELENIE = @"oddelenie";

// tabulka pre id ucitelov, ktori ucia danu hodinu
static  NSString *TB_HODKRUZOK = @"hodkruzok";
static  NSString *COLUMN_HODKRUZOK_IDHODINY = @"idHodiny";
static  NSString *COLUMN_HODKRUZOK_IDKRUZKU = @"idKruzku";

// tabulka pre oblubene rozvry
static  NSString *TB_OBLUBENE = @"hodkruzok";
static  NSString *COLUMN_OBLUBENE_ID = @"id";
static  NSString *COLUMN_OBLUBENE_IDHODINY = @"idHodiny";
static  NSString *COLUMN_OBLUBENE_NAME = @"name";

// tabulka pre info o rozvrhu
static  NSString *TB_INFO = @"info";
static  NSString *COLUMN_INFO_VERZIA = @"verzia";
static  NSString *COLUMN_INFO_SKOLROK = @"skolrok";
static  NSString *COLUMN_INFO_SEMESTER = @"semester";


+(Database*)getSharedInstance{
    if(!sharedInstance){
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

-(BOOL) createDB{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: @"candleDB.db"]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            char *errMsg;
            NSString *create_query = [NSString stringWithFormat:@"CREATE TABLE %@(%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT);",TB_HODINY_NAME,COLUMN_HODINY_ID,COLUMN_HODINY_DEN,COLUMN_HODINY_ZACIATOK,COLUMN_HODINY_KONIEC,COLUMN_HODINY_MIESTNOST,COLUMN_HODINY_TRVANIE,COLUMN_HODINY_PREDMET,COLUMN_HODINY_UCITELIA,COLUMN_HODINY_KRUZKY,COLUMN_HODINY_TYP,COLUMN_HODINY_KOD_PREDMETU,COLUMN_HODINY_KREDITY,COLUMN_HODINY_ROZSAH,COLUMN_HODINY_KAPACITA_MIESTNOSTI,COLUMN_HODINY_TYP_MIESTRNOSTI];
            const char *sql_stmt = [create_query cStringUsingEncoding:NSUTF8StringEncoding];
            
            NSLog(create_query);
            
            
         	if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            
			// vytvorenie tablulky hoducitel (`idHodiny`, `idUcitela`,
			// `katedra`, `meno`, `oddelenie`, `priezvisko`)
            create_query = [NSString stringWithFormat:@"CREATE TABLE %@(%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT);",TB_HODUCITEL,COLUMN_HODUCITEL_IDHODINY,COLUMN_HODUCITEL_IDUCITELA,COLUMN_HODUCITEL_KATEDRA,COLUMN_HODUCITEL_MENO,COLUMN_HODUCITEL_ODDELENIE,COLUMN_HODUCITEL_PRIEZVISKO];
            sql_stmt = [create_query cStringUsingEncoding:NSUTF8StringEncoding];
            
            //            DLog("create Query",sql_stmt);
            
            
         	if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
    
            // vytvorenie tablulky hodkruzok
            create_query = [NSString stringWithFormat:@"CREATE TABLE %@(%@ TEXT,%@ TEXT);",TB_HODKRUZOK,COLUMN_HODKRUZOK_IDHODINY,COLUMN_HODKRUZOK_IDKRUZKU];
            sql_stmt = [create_query cStringUsingEncoding:NSUTF8StringEncoding];                      
            
         	if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }

            
			// vytvorenie tabulky info, sluzi na uchovanie verzie,skrok a
			// semester
            create_query = [NSString stringWithFormat:@"CREATE TABLE %@(%@ TEXT,%@ TEXT,%@ TEXT);",TB_INFO,COLUMN_INFO_VERZIA,COLUMN_INFO_SKOLROK,COLUMN_INFO_SEMESTER];
            sql_stmt = [create_query cStringUsingEncoding:NSUTF8StringEncoding];
            
         	if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            
			// vytvorenie tabulky pre oblubene rozvrhy
            create_query = [NSString stringWithFormat:@"CREATE TABLE %@(%@ NOT NULL AUTO_INCREMENT,%@ TEXT);",TB_OBLUBENE,COLUMN_OBLUBENE_ID,COLUMN_OBLUBENE_NAME];
            sql_stmt = [create_query cStringUsingEncoding:NSUTF8StringEncoding];
            
         	if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            
			// indexy na zrychlenie databzy
            create_query = [NSString stringWithFormat:@"CREATE INDEX i1 ON %@(%@);",TB_HODKRUZOK,COLUMN_HODKRUZOK_IDKRUZKU];
            sql_stmt = [create_query cStringUsingEncoding:NSUTF8StringEncoding];
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create indexes");
            }
            
            create_query = [NSString stringWithFormat:@"CREATE INDEX i2 ON %@(%@);",TB_HODUCITEL,COLUMN_HODUCITEL_PRIEZVISKO];
            sql_stmt = [create_query cStringUsingEncoding:NSUTF8StringEncoding];
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create indexes");
            }
            sqlite3_close(database);
            return  isSuccess;
        }
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    return isSuccess;
}

-(BOOL) deleteDataFromDB{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"DELETE FROM %@,%@,%@,%@",TB_HODINY_NAME,TB_HODKRUZOK,TB_HODUCITEL,TB_INFO];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database,query_stmt, -1, &statement, NULL) == SQLITE_OK){
            while(sqlite3_step(statement) == SQLITE_ROW) {
                NSLog(@"deleting");
            }
            return YES;
        }
    }
    return NO;
}
-(BOOL) deleteDatabase{
    return NO;
}

-(NSArray *) searchLessonsByRoom:(NSString*)room{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT h.%@, h.%@, h.%@, h.%@, h.%@, h.%@, h.%@, h.%@ FROM %@ h, WHERE h.%@ ='%@' "
                              ,COLUMN_HODINY_DEN,COLUMN_HODINY_ZACIATOK,COLUMN_HODINY_KONIEC,COLUMN_HODINY_TRVANIE,COLUMN_HODINY_MIESTNOST,COLUMN_HODINY_TYP,COLUMN_HODINY_PREDMET,COLUMN_HODINY_UCITELIA,TB_HODINY_NAME,COLUMN_HODINY_MIESTNOST,room];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *day = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                NSString *start = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSString *end = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                NSNumber *duration = [[NSNumber alloc] initWithInt: sqlite3_column_int(statement, 3)];
                NSString *room = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text (statement, 4)];
                NSString *type = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                NSString *name = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                NSString *teachers = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)];
                
                
                Predmet *predmet = [Predmet initWithName:name andRoom:room andDay:day andStart:start andEnd:end andDuration:duration andType:type andTeachers:teachers];
                NSLog(predmet);
                [resultArray addObject:predmet];
                return resultArray;
            }
            else{
                NSLog(@"Not found");
                return nil;
            }
            sqlite3_reset(statement);
        }
    }
    return nil;

}
-(NSArray *) searchLessonsByClass:(NSString*) kruzok{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT h.%@, h.%@, h.%@, h.%@, h.%@, h.%@, h.%@, h.%@ FROM %@ h , %@ k WHERE h.%@ = k.%@ AND k.%@ = '%@'"
                              ,COLUMN_HODINY_DEN,COLUMN_HODINY_ZACIATOK,COLUMN_HODINY_KONIEC,COLUMN_HODINY_TRVANIE,COLUMN_HODINY_MIESTNOST,COLUMN_HODINY_TYP,COLUMN_HODINY_PREDMET,COLUMN_HODINY_UCITELIA,TB_HODINY_NAME,TB_HODKRUZOK,COLUMN_HODINY_ID,COLUMN_HODKRUZOK_IDHODINY,COLUMN_HODKRUZOK_IDKRUZKU,kruzok];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                 NSString *day = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                 NSString *start = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                 NSString *end = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                 NSNumber *duration = [[NSNumber alloc] initWithInt: sqlite3_column_int(statement, 3)];
                 NSString *room = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text (statement, 4)];
                 NSString *type = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                 NSString *name = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                 NSString *teachers = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)];
               
                
                Predmet *predmet = [Predmet initWithName:name andRoom:room andDay:day andStart:start andEnd:end andDuration:duration andType:type andTeachers:teachers];
                NSLog(predmet);
                [resultArray addObject:predmet];
                return resultArray;
            }
            else{
                NSLog(@"Not found");
                return nil;
            }
            sqlite3_reset(statement);
        }
    }
    return nil;
}
-(NSArray *) searchLessonsByTeacher:(NSString*) priezvisko meno:(NSString*)meno{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT h.%@, h.%@, h.%@, h.%@, h.%@, h.%@, h.%@, h.%@ FROM %@ h , %@ k WHERE k.%@ = h.%@ AND k.%@ = '%@' AND k.%@ = '%@'"
                              ,COLUMN_HODINY_DEN,COLUMN_HODINY_ZACIATOK,COLUMN_HODINY_KONIEC,COLUMN_HODINY_TRVANIE,COLUMN_HODINY_MIESTNOST,COLUMN_HODINY_TYP,COLUMN_HODINY_PREDMET,COLUMN_HODINY_UCITELIA,TB_HODINY_NAME,TB_HODUCITEL,COLUMN_HODUCITEL_IDHODINY,COLUMN_HODINY_ID,COLUMN_HODUCITEL_PRIEZVISKO,priezvisko,COLUMN_HODUCITEL_MENO,meno];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *day = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                NSString *start = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSString *end = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                NSNumber *duration = [[NSNumber alloc] initWithInt: sqlite3_column_int(statement, 3)];
                NSString *room = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text (statement, 4)];
                NSString *type = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                NSString *name = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                NSString *teachers = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)];
                
                Predmet *predmet = [Predmet initWithName:name andRoom:room andDay:day andStart:start andEnd:end andDuration:duration andType:type andTeachers:teachers];
                NSLog(predmet);
                [resultArray addObject:predmet];
                return resultArray;
            }
            else{
                NSLog(@"Not found");
                return nil;
            }
            sqlite3_reset(statement);
        }
    }
    return nil;
}
-(NSArray *) getTimeTableInfo{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM %@",TB_INFO];
                        
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
               // co chceme vlastne zistovat?
            }
            else{
                NSLog(@"Not found");
                return nil;
            }
            sqlite3_reset(statement);
        }
    }
    return nil;
}

-(BOOL)addFavouriteTimeTable:(NSString *)name{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"INSERT INTO %@ VALUES (null, '%@')",TB_OBLUBENE,name];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {            
            return YES;
        }
    }
    return NO;
}

-(NSArray *)getNamesOfFavourites{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT DISTINCT %@ FROM %@",COLUMN_OBLUBENE_NAME,TB_OBLUBENE];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *fav = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
                
                NSLog(fav);
                [resultArray addObject:fav];
                return resultArray;
            }
            else{
                NSLog(@"Not found");
                return nil;
            }
            sqlite3_reset(statement);
        }
    }
    return nil;
}
-(NSArray *)getSimiliarTeachers:(NSString*) teacher{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
         NSString *querySQL = [NSString stringWithFormat:@"SELECT DISTINCT %@,%@ FROM %@ WHERE %@ LIKE '%@%%'", COLUMN_HODUCITEL_PRIEZVISKO,COLUMN_HODUCITEL_MENO,TB_HODUCITEL,COLUMN_HODUCITEL_PRIEZVISKO,teacher];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *meno = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSString *priezvisko = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                NSString *teacher = [NSString stringWithFormat:@"%@ %@",meno,priezvisko];              
                
                
                [resultArray addObject:teacher];
                return resultArray;
            }
            else{
                NSLog(@"Not found");
                return nil;
            }
            sqlite3_reset(statement);
        }
    }
    return nil;
}

-(NSArray *)getSimilarRooms:(NSString*) room{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT DISTINCT %@ FROM %@ WHERE %@ LIKE '%@%%'", COLUMN_HODINY_MIESTNOST,TB_HODINY_NAME,COLUMN_HODINY_MIESTNOST,room];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *room = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
                
                NSLog(room);
                [resultArray addObject:room];
                return resultArray;
            }
            else{
                NSLog(@"Not found");
                return nil;
            }
            sqlite3_reset(statement);
        }
    }
    return nil;
}

-(NSArray *)getSimilarClass:(NSString*) clas{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT DISTINCT %@ FROM %@ WHERE %@ LIKE '%@%%'", COLUMN_HODKRUZOK_IDKRUZKU,TB_HODKRUZOK,COLUMN_HODKRUZOK_IDKRUZKU,clas];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *similarClass = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];

                [resultArray addObject:similarClass];
                return resultArray;
            }
            else{
                NSLog(@"Not found");
                return nil;
            }
            sqlite3_reset(statement);
        }
    }
    return nil;
}



@end