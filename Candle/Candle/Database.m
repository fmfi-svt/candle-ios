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


-(NSArray *) searchLessonsByRoom:(NSString*)room{
    
}
-(NSArray *) searchLessonsByClass:(NSString*) kruzok{
}

-(NSArray *) searchLessonsByTeacher:(NSString*) priezvisko meno:(NSString*)meno{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT name, department, year from studentsDetail where
                              regno=\"%@\"",registerNumber];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *name = [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 0)];
                [resultArray addObject:name];
                NSString *department = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 1)];
                [resultArray addObject:department];
                NSString *year = [[NSString alloc]initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 2)];
                [resultArray addObject:year];
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
                NSString *name = [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 0)];
                [resultArray addObject:name];
                NSString *department = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 1)];
                [resultArray addObject:department];
                NSString *year = [[NSString alloc]initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 2)];
                [resultArray addObject:year];
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

	// vyhladavanie v databaze podla miestnosti
	public Cursor searchLessonsByRoom(String room) {
		database = dbHelper.getReadableDatabase();
		final String MY_QUERY = "SELECT h." + COLUMN_HODINY_DEN + ", h."
        + COLUMN_HODINY_ZACIATOK + ", h." + COLUMN_HODINY_KONIEC
        + ", h." + COLUMN_HODINY_TRVANIE + ", h."
        + COLUMN_HODINY_MIESTNOST + ", h." + COLUMN_HODINY_TYP + ", h."
        + COLUMN_HODINY_PREDMET + ", h." + COLUMN_HODINY_UCITELIA
        + " FROM " + TB_HODINY_NAME + " h WHERE " + " h."
        + COLUMN_HODINY_MIESTNOST + " =\"" + room + "\" ";
        
		Cursor cursor = database.rawQuery(MY_QUERY, null);
		Log.d("cursor searchLessonsByRoom", Integer.toString(cursor.getCount()));
		database.close();
		return cursor;
	}
    
	// vyhladavanie v databaze podla kruzkov
	public Cursor searchLessonsByClass(String kruzok) {
		database = dbHelper.getReadableDatabase();
		final String MY_QUERY = "SELECT h." + COLUMN_HODINY_DEN + ", h."
        + COLUMN_HODINY_ZACIATOK + ", h." + COLUMN_HODINY_KONIEC
        + ", h." + COLUMN_HODINY_TRVANIE + ", h."
        + COLUMN_HODINY_MIESTNOST + ", h." + COLUMN_HODINY_TYP + ", h."
        + COLUMN_HODINY_PREDMET + ", h." + COLUMN_HODINY_UCITELIA
        + " FROM " + TB_HODINY_NAME + " h , " + TB_HODKRUZOK
        + " k WHERE " + "h." + COLUMN_HODINY_ID + " = k."
        + COLUMN_HODKRUZOK_IDHODINY + " AND k."
        + COLUMN_HODKRUZOK_IDKRUZKU + " = \"" + kruzok + "\"";
        
		Cursor cursor = database.rawQuery(MY_QUERY, null);
        
		Log.d("cursor searchLessonsByClass",
              Integer.toString(cursor.getCount()));
		database.close();
		return cursor;
	}
    
	// PRIDAT POROVNANIIE AJ PODLA MENA NIE LEN PODLA PRIEZVISKA!!!!!!!!!!
	// vyhladavanie v databaze podla ucitelov
	public Cursor searchLessonsByTeacher(String priezvisko, String meno) {
		database = dbHelper.getReadableDatabase();
		final String MY_QUERY = "SELECT h." + COLUMN_HODINY_DEN + ", h."
        + COLUMN_HODINY_ZACIATOK + ", h." + COLUMN_HODINY_KONIEC
        + ", h." + COLUMN_HODINY_TRVANIE + ", h."
        + COLUMN_HODINY_MIESTNOST + ", h." + COLUMN_HODINY_TYP + ", h."
        + COLUMN_HODINY_PREDMET + ", h." + COLUMN_HODINY_UCITELIA
        + " FROM " + TB_HODINY_NAME + " h , " + TB_HODUCITEL
        + " k WHERE " + "k." + COLUMN_HODUCITEL_IDHODINY + " = h."
        + COLUMN_HODINY_ID + " AND k." + COLUMN_HODUCITEL_PRIEZVISKO
        + " = \"" + priezvisko + "\" AND k." + COLUMN_HODUCITEL_MENO
        + " = \"" + meno + "\"";
        
		Cursor cursor = database.rawQuery(MY_QUERY, null);
		Log.d("cursor searchLessonsByTeacher",
              Integer.toString(cursor.getCount()));
		database.close();
		return cursor;
	}
    
	public Cursor dajInfoRozvrhu() {
		database = dbHelper.getWritableDatabase();
		final String MY_QUERY = "SELECT * FROM " + TB_INFO;
		Cursor cursor = database.rawQuery(MY_QUERY, null);
		Log.d("cursor DBM", Integer.toString(cursor.getCount()));
		database.close();
		return cursor;
	}
    
	// zmaze vsetky riadky tabuliek, ale zachova sa struktura = nevola sa
	// onCreate!
	public void vymazRiadkyDatabazy() {
		database = dbHelper.getWritableDatabase();
		database.delete(TB_HODINY_NAME, null, null);
		database.delete(TB_HODKRUZOK, null, null);
		database.delete(TB_HODUCITEL, null, null);
		database.delete(TB_INFO, null, null);
		database.close();
	}
    
	public void insertTable(String string) {
		database = dbHelper.getWritableDatabase();
		database.execSQL(string);
	}
    
	// testovanie tabuliek
	public Cursor checkTable(String TB_NAME) {
		database = dbHelper.getReadableDatabase();
		final String MY_QUERY = "SELECT * FROM " + TB_NAME;
        
		Cursor cursor = database.rawQuery(MY_QUERY, null);
		Log.d("cursor DBM", Integer.toString(cursor.getCount()));
		database.close();
		// cursor.moveToFirst();
		// for (int i = 0; i < cursor.getCount(); i += 100) {
		//
		// for (int j = 0; j < cursor.getColumnCount(); j++) {
		// Log.d("test",cursor.getColumnName(j) + " " +cursor.getString(j));
		// }
		// Log.d("test", "????????????????????????????");
		// cursor.moveToNext();
		// }
		cursor.close();
		return cursor;
        
	}
    
	// vymaze databazu aj zo strukturou
	public void zmamDatabazu() {
		context.deleteDatabase(DATABASE_NAME);
	}
    
	public Cursor searchByQuery(String query) {
		database = dbHelper.getWritableDatabase();
		Cursor cursor = database.rawQuery(query, null);
		Log.d("cursor DBM", Integer.toString(cursor.getCount()));
		database.close();
		return cursor;
	}
    
	public Cursor getSimilarRooms(String room) {
		final String MY_QUERY = "SELECT DISTINCT " + COLUMN_HODINY_MIESTNOST
        + " FROM " + TB_HODINY_NAME + " WHERE "
        + COLUMN_HODINY_MIESTNOST + " LIKE \"" + room + "%\"";
		return searchByQuery(MY_QUERY);
	}
    
	public Cursor getSimilarTeachers(String teacher) {
		final String MY_QUERY = "SELECT DISTINCT "
        + COLUMN_HODUCITEL_PRIEZVISKO + " , " + COLUMN_HODUCITEL_MENO
        + " FROM " + TB_HODUCITEL + " WHERE "
        + COLUMN_HODUCITEL_PRIEZVISKO + " LIKE \"" + teacher + "%\"";
		return searchByQuery(MY_QUERY);
	}
    
	public Cursor getSimilarClass(String string) {
		final String MY_QUERY = "SELECT DISTINCT " + COLUMN_HODKRUZOK_IDKRUZKU
        + " FROM " + TB_HODKRUZOK + " WHERE "
        + COLUMN_HODKRUZOK_IDKRUZKU + " LIKE \"" + string + "%\"";
		return searchByQuery(MY_QUERY);
	}
    
	public void addFavoriteTimeTable(String name) {
		final String MY_QUERY = "INSERT INTO " + TB_OBLUBENE
        + " VALUES (null, " + name+ ")";
		database.execSQL(MY_QUERY);
	}
    
	public Cursor giveNamesFromFavorites() {
		final String MY_QUERY = "SELECT DISTINCT " + COLUMN_OBLUBENE_NAME
        + " FROM " + TB_OBLUBENE;
		return searchByQuery(MY_QUERY);
	}
}

@end