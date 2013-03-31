//
//  ZoznamPredmetov.h
//  Candle
//
//  Created by Pejko Salik on 11/25/12.
//  Copyright (c) 2012 Peter Sulik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"
#import "NSString+ParsingExtensions.h"

@interface ZoznamPredmetov : NSObject {
    sqlite3 *db;    
}

@property(readwrite,retain) NSString *username;
@property(readwrite,retain) NSMutableArray *predmety;


- (void) nastavUsername:(UITextField *)UIUserNameTextField;

+ (id) zoznamPredmetovWithDefaultURLandNick: (NSString *)nick AndWithError: (NSError **) error;

// toto by mohol byt nejaka CandleNet clasa
+ (BOOL) checkConnection;
+ (BOOL) downloadCandleCSV:(NSString *)nazovRozvrhu;
+ (NSString *) downloadedCSVFilePath;

// toto zoznam predmetov
- (BOOL) getDataFromCSV:(NSString *)filePath;
- (NSMutableArray *) getLessonsForDay:(int)den;

// CandleLocalDB napriklad?
- (void) setLocalDbFromParsedXML:(NSArray *)poleNaInsert;
- (NSMutableArray *) getLessonsFromDB;


@end
