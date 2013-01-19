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
@property(readwrite, retain) NSNumber *predmetId;
@property(readwrite, retain) NSString *name;
@property(readwrite, retain) NSString *room;
@property(readwrite, retain) NSNumber *day;
@property(readwrite, retain) NSNumber *start;
@property(readwrite, retain) NSNumber *classLength;

/*
 neviem ako je to originalne uskladnene,
 tiez ci cas je rozdeleny na hodinu a minuty alebo sa to vzdy parsuje
 alebo ako nejaky integer
 */
-(id)initWithName:(NSNumber*)aPredmetId
        andName:(NSString*)aName
        andRoom:(NSNumber*)aRoom
        andDay:(NSNumber*)aDay
        andStart:(NSNumber*)aStart
        andClassLength:(NSNumber*)aClassLength;


- (NSString *)description;
@end