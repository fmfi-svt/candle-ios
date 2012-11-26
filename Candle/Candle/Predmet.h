//
//  Predmet.h
//  Candle
//
//  Created by Pejko Salik on 11/26/12.
//  Copyright (c) 2012 Peter Sulik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Predmet : NSObject{
    NSString *name;
    NSString *room;
    NSNumber *day;
    NSString *start;
    NSNumber *length;
}
@property(readwrite, retain) NSString *name;
@property(readwrite, retain) NSString *room;
@property(readwrite, retain) NSNumber *day;
@property(readwrite, retain) NSString *start;
@property(readwrite, retain) NSNumber *lengthOfLesson;

/*
 neviem ako je to originalne uskladnene,
 tiez ci cas je rozdeleny na hodinu a minuty alebo sa to vzdy parsuje
 alebo ako nejaky integer
 */


@end
