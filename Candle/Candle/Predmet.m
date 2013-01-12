//
//  Predmet.m
//  Candle
//
//  Created by Pejko Salik on 11/26/12.
//  Copyright (c) 2012 Peter Sulik. All rights reserved.
//

#import "Predmet.h"

@implementation Predmet

@synthesize predmetId;
@synthesize name;
@synthesize room;
@synthesize day;
@synthesize start;
@synthesize classLength;

-(id)initWithName:(NSNumber*)aPredmetId
          andName:(NSString*)aName andRoom:(NSString *)aRoom andDay:(NSNumber *)aDay andStart:(NSNumber *)aStart andClassLength:(NSNumber *)aClassLength
{
    self = [super init];
    if(self){
        self.predmetId = aPredmetId;
        self.name =	aName;
        self.room = aRoom;
        self.day = aDay;
        self.start = aStart;
        self.classLength = aClassLength;
        
    }
    return self;
}





@end
