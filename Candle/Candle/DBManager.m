//
//  DBManager.m
//  Candle
//
//  Created by Pejko Salik on 6/21/13.
//  Copyright (c) 2013 Peter Sulik. All rights reserved.
//

#import "DBManager.h"
static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation DBManager

+(DBManager*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}


-(id)init{
    self = [super init];
    if(self){
    
    dbMan = [[Database alloc] init];
    if([[dbMan getTimeTableInfo] count] == 0){
        if([self isConnectedToInternet]){
            if([[self  checkVersionInternet] isEqualToString:[self checkVersionFile]]){
//            parseFromFile;
            } else {
//                parseFromInternet;
            }
        } else {
//            parseFromFile;
        }
    } else {
        if([self isConnectedToInternet]){
            NSString *fileVersion = [[dbMan getTimeTableInfo] objectAtIndex:0];
            if([[self checkVersionInternet] isEqualToString:fileVersion]){
                //                parseFromInternet;
            }
        }
    }
        
    }
    return self;
}


+(BOOL) isConnectedToInternet{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if(internetStatus == NotReachable) {
        return NO;
    }
    return YES;
}

-(NSString *)getVersionFromString:(NSString *)input{
    NSScanner *scan = [[NSScanner alloc] initWithString:input];
    NSString *part;
    [scan scanUpToString:@"verzia=\"" intoString:&part];
    [scan scanUpToString:@"\"" intoString:&part];
    NSLog(@"Verzia %@",part);
    return part;
}
-(NSString *)checkVersionFile{
    NSString *sqlfile; // sem treba nastavit cestu k sqlfilu
    NSError *error;    
    NSString *fileContents = [NSString stringWithContentsOfFile:sqlfile usedEncoding:NSUTF8StringEncoding error:&error];
    
    return [self getVersionFromString:fileContents];
}
-(NSString *)checkVersionInternet{
    NSError *error;
    NSURL *url;
    NSString *fileContents = [NSString stringWithContentsOfURL:url usedEncoding:NSUTF8StringEncoding error:&error];
    
    return [self getVersionFromString:fileContents];
}
-(void)parse:(NSFileHandle *)file{
    
}
-(NSArray *)getSimiliarStrings:(NSString *)string{
    NSMutableArray *strings = [[NSMutableArray alloc] init];
    [strings addObjectsFromArray: [dbMan getSimilarRooms:string]];
    [strings addObjectsFromArray: [dbMan getSimilarClass:string]];
    [strings addObjectsFromArray: [dbMan getSimilarTeachers:string]];
    return strings;
}
-(TimeTable *)getTimeTableAccordingTOString:(NSString *)string{
    lessons = [[NSMutableArray alloc] init];
    NSMutableString *idTimeTable = [[NSMutableString alloc] init];
    NSString *stringParsed;
    NSScanner *scan = [[NSScanner alloc] initWithString:string];
//    if(![scan isAtEnd]){
//        [idTimeTable appendFormat: @"Učiteľ: %@",string];
//        stringParsed = [scan scanString:<#(NSString *)#> intoString:<#(NSString *__autoreleasing *)#>;
//        if(scan.hasNext()){
//            String stringParsed2 = scan.next();
//            cursor = dbManager.searchLessonsByTeacher(stringParsed, stringParsed2);
//        } else {
//            //ak string je jedno slovo a zacina na pismeno tak je to miestnost
//            if(Character.isLetter(string.charAt(0))){
//                idTimetable = "Miestnosť: " + string;
//                cursor = dbManager.searchLessonsByRoom(string);
//            } else {
//                // ostava kruzok
//                idTimetable = "Krúžok: " + string;
//                cursor = dbManager.searchLessonsByClass(string);
//            }
//        }
//    } else {
//        Log.d("parsovanie stringu", "prazdny string");
//    }
//    Log.d("according string cursor", "pocet riadkov = " + cursor.getCount());
//    cursor.moveToFirst();
//    while (!cursor.isAfterLast()) {
//        Lesson lesson = new Lesson(cursor.getString(0),
//                                   cursor.getString(1), cursor.getString(2),
//                                   Integer.parseInt(cursor.getString(3)), cursor.getString(4),
//                                   cursor.getString(5), cursor.getString(6),
//                                   cursor.getString(7));
//        lessons.add(lesson);
//        cursor.moveToNext();
//    }
//    cursor.close();
//    
    TimeTable *tt = [[TimeTable alloc] initWithLessons:lessons];
    tt.idTimetable = idTimeTable;
    return tt;
    
}
-(void)addFavouriteTimeTable:(NSString *)name{
    [dbMan addFavouriteTimeTable:name];
}
-(NSArray *)getStringsFromFavourites:(NSString *)string{
    return [dbMan getNamesOfFavourites];
}





@end
