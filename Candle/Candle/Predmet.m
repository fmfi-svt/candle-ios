//
//  Predmet.m
//  Candle
//
//  Created by Pejko Salik on 11/26/12.
//  Copyright (c) 2012 Peter Sulik. All rights reserved.
//

#import "Predmet.h"

@implementation Predmet

-(id) initWithName:(NSString*)aName andRoom:(NSString *)aRoom andDay:(NSString *)aDay andStart:(NSString *)aStart andEnd:(NSString*)aEnd andDuration:(NSNumber *)aDuration andType:(NSString*)aType andTeachers:(NSString *)aTeachers
{
    self = [super init];
    if(self){
        _name =	aName;
        _room = aRoom;
        _day = aDay;
        _start = aStart;
        _end = aEnd;
        _duration = aDuration;
        _type = aType;
        _teachers = aTeachers;
        
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat: @"name : %@ \r room : %@ \r day: %@ \r start : %@ \r end : %@ \r classLength : %@ type : %@ \r teachers : %@ \r" , self.name, self.room, self.day, self.start, self.end, self.duration, self.type, self.teachers];
}
@end
