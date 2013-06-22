//
//  DBManager.m
//  Candle
//
//  Created by Pejko Salik on 6/21/13.
//  Copyright (c) 2013 Peter Sulik. All rights reserved.
//

#import "DBManager.h"
static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation DBManager

+(DBManager*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}


-(id)init{
    self = [super init];
    if(self){
    
    dbMan = [[Database alloc] init];
    if([[dbMan getTimeTableInfo] count] == 0){
        if([self isConnectedToInternet]){
            if([[self  checkVersionInternet] isEqualToString:[self checkVersionFile]]){
//            parseFromFile;
            } else {
//                parseFromInternet;
            }
        } else {
//            parseFromFile;
        }
    } else {
        if([self isConnectedToInternet]){
            NSString *fileVersion = [[dbMan getTimeTableInfo] objectAtIndex:0];
            if([[self checkVersionInternet] isEqualToString:fileVersion]){
                //                parseFromInternet;
            }
        }
    }
        
    }
    return self;
}


+(BOOL) isConnectedToInternet{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if(internetStatus == NotReachable) {
        return NO;
    }
    return YES;
}

-(NSString *)getVersionFromString:(NSString *)input{
    NSScanner *scan = [[NSScanner alloc] initWithString:input];
    NSString *part;
    [scan scanUpToString:@"verzia=\"" intoString:&part];
    [scan scanUpToString:@"\"" intoString:&part];
    NSLog(@"Verzia %@",part);
    return part;
}
-(NSString *)checkVersionFile{
    NSString *sqlfile; // sem treba nastavit cestu k sqlfilu
    NSError *error;    
    NSString *fileContents = [NSString stringWithContentsOfFile:sqlfile usedEncoding:NSUTF8StringEncoding error:&error];
    
    return [self getVersionFromString:fileContents];
}
-(NSString *)checkVersionInternet{
    NSError *error;
    NSURL *url;
    NSString *fileContents = [NSString stringWithContentsOfURL:url usedEncoding:NSUTF8StringEncoding error:&error];
    
    return [self getVersionFromString:fileContents];
}
-(void)parse:(NSFileHandle *)file{
    
}
-(NSArray *)getSimiliarStrings:(NSString *)string{
    NSMutableArray *strings = [[NSMutableArray alloc] init];
    [strings addObjectsFromArray: [dbMan getSimilarRooms:string]];
    [strings addObjectsFromArray: [dbMan getSimilarClass:string]];
    [strings addObjectsFromArray: [dbMan getSimilarTeachers:string]];
    return strings;
}
-(TimeTable *)getTimeTableAccordingTOString:(NSString *)string{
    
}
-(void)addFavouriteTimeTable:(NSString *)name{
    
}
-(NSArray *)getStringsFromFavourites:(NSString *)string{
    
}





@end
