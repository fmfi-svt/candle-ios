//
//  Database.h
//  Candle
//
//  Created by Pejko Salik on 6/21/13.
//  Copyright (c) 2013 Peter Sulik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Predmet.h"

@interface Database : NSObject
{
    NSString *databasePath;
}

+(Database*)getSharedInstance;
-(BOOL) createDB;
-(BOOL) deleteDataFromDB;
-(BOOL) deleteDatabase;

-(NSArray *) searchLessonsByRoom:(NSString*)room;
-(NSArray *) searchLessonsByClass:(NSString*) kruzok;
-(NSArray *) searchLessonsByTeacher:(NSString*) priezvisko meno:(NSString*)meno;
-(NSArray *) getTimeTableInfo;


-(BOOL)addFavouriteTimeTable:(NSString*) name;

-(NSArray *)getNamesOfFavourites;
-(NSArray *)getSimiliarTeachers:(NSString*) teacher;
-(NSArray *)getSimilarRooms:(NSString*) room;
-(NSArray *)getSimilarClass:(NSString*) clas;
-(void) closeDB;

@end

