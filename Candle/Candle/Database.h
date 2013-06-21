//
//  Database.h
//  Candle
//
//  Created by Pejko Salik on 6/21/13.
//  Copyright (c) 2013 Peter Sulik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Database : NSObject
{
    NSString *databasePath;
}

+(Database*)getSharedInstance;
-(BOOL) createDB;
-(BOOL) deleteDataFromDB;
-(BOOL) deleteDatabase;

-(BOOL) insertTable:(NSString*) query;



-(NSArray *) searchLessonsByRoom:(NSString*)room;
-(NSArray *) searchLessonsByClass:(NSString*) kruzok;
-(NSArray *) searchLessonsByTeacher:(NSString*) priezvisko meno:(NSString*)meno;
-(NSArray *) getTimeTableInfo;


-addFavouriteTimeTable:(NSString*) name;

-(NSArray *)getNamesFromFavourites;
-(NSArray *)getSimiliarTeachers:(NSString*) teacher;
-(NSArray *)getSimilarRooms:(NSString*) room;
-(NSArray *)getSimilarClass:(NSString*) clas;
-(NSArray *)searchByQuery:(NSString*) query;
-(void) closeDB;

@end

