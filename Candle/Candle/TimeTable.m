//
//  TimeTable.m
//  Candle
//
//  Created by Pejko Salik on 6/22/13.
//  Copyright (c) 2013 Peter Sulik. All rights reserved.
//

#import "TimeTable.h"
#import "Predmet.h"
@implementation TimeTable


-(id) initWithLessons:(NSArray*) aLessons{
    self = [super init];
    if(!self){
        lessons = [NSMutableArray arrayWithArray:aLessons];
    }
    return self;
}
-(BOOL) isEmpty{
    return lessons.count == 0;
}
-(NSString *)description{
    if(!lessons){
            return @"Rozvrh nie je nastaveny";
    } else
    {
        NSMutableString *desc = [[NSMutableString alloc] initWithString:@"Timetable:"];
        for (Predmet *predmet in lessons) {
            [desc appendFormat:@"%@ \n\n",[predmet description]];
        }
        return (NSString *) desc;
    }
    
    
}



@end




