//
//  DBManager.h
//  Candle
//
//  Created by Pejko Salik on 6/21/13.
//  Copyright (c) 2013 Peter Sulik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Database.h"
#import "TimeTable.h"
#import "Reachability.h"
@interface DBManager : NSObject
{
    NSString *databasePath;
    Database *dbMan;
    TimeTable *timeTable;
    NSMutableArray *lessons;
}


-(id)init;

+(DBManager *)getSharedInstance;
-(BOOL)createDB;

-(NSString *)getVersionFromString:(NSString *)input;
-(BOOL)isConnectedToInternet;
-(NSString *)checkVersionFile;
-(NSString *)checkVersionInternet;
-(void)parse:(NSFileHandle *)file;
-(NSArray *)getSimiliarStrings:(NSString *)string;
-(TimeTable *)getTimeTableAccordingTOString:(NSString *)string;
-(void)addFavouriteTimeTable:(NSString *)name;
-(NSArray *)getStringsFromFavourites:(NSString *)string;



-(BOOL) saveData:(NSString*)registerNumber name:(NSString*)name
      department:(NSString*)department year:(NSString*)year;
-(NSArray*) findByRegisterNumber:(NSString*)registerNumber;

@end
