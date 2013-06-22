//
//  TimeTable.h
//  Candle
//
//  Created by Pejko Salik on 6/22/13.
//  Copyright (c) 2013 Peter Sulik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeTable : NSObject
{ 
    NSMutableArray *lessons;
}
@property(readwrite, retain) NSString *idTimetable;

-(id) initWithLessons:(NSArray*) aLessons;
-(BOOL) isEmpty;
-(NSString *)description;

@end
