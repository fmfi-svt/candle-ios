//
//  Predmet.h
//  Candle
//
//  Created by Pejko Salik on 11/26/12.
//  Copyright (c) 2012 Peter Sulik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Predmet : NSObject{
}
@property(readwrite, retain) NSString *name;
@property(readwrite, retain) NSString *room;
@property(readwrite, retain) NSNumber *day;
@property(readwrite, retain) NSString *start;
@property(readwrite, retain) NSString *end;
@property(readwrite, retain) NSNumber *duration;
@property(readwrite, retain) NSString *teachers;
@property(readwrite, retain) NSString *type;


-(id)initWithName:(NSString*)aName
        andRoom:(NSNumber*)aRoom
        andDay:(NSNumber*)aDay
        andStart:(NSString*)aStart
        andEnd:(NSString*)aEnd
        andClassLength:(NSNumber*)aClassLength
        andType:(NSString*)aType
        andTeachers:(NSString *)aTeachers
;


- (NSString *)description;
@end