//
//  Predmet.m
//  Candle
//
//  Created by Pejko Salik on 11/26/12.
//  Copyright (c) 2012 Peter Sulik. All rights reserved.
//

#import "Predmet.h"

@implementation Predmet

-(id)initWithName:(NSNumber*)aPredmetId
          andName:(NSString*)aName andRoom:(NSString *)aRoom andDay:(NSNumber *)aDay andStart:(NSString *)aStart andClassLength:(NSNumber *)aClassLength
{
    self = [super init];
    if(self){
        _predmetId = aPredmetId;
        _name =	aName;
        _room = aRoom;
        _day = aDay;
        _start = aStart;
        _classLength = aClassLength;
        
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat: @"predmetId : %@ \r name : %@ \r room : %@ \r day: %@ \r start : %@ \r classLength : %@", self.predmetId, self.name, self.room, self.day, self.start, self.classLength];
}
@end
