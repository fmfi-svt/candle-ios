//
//  ZoznamPredmetov.m
//  Candle
//
//  Created by Pejko Salik on 11/25/12.
//  Copyright (c) 2012 Peter Sulik. All rights reserved.
//

#import "ZoznamPredmetov.h"
#import "Predmet.h"





@implementation ZoznamPredmetov


+ (id) zoznamPredmetovWithDefaultURLandNick: (NSString *)nick {
    ZoznamPredmetov *zp = [[self alloc] init];
    if ([ZoznamPredmetov checkConnection]) {
        if([zp getDataFromCSV:[ZoznamPredmetov downloadCandleCSV:nick]]){
            return zp;
        }
    }
    return nil;
}

+(bool) checkConnection{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if(internetStatus == NotReachable) {
        return false;
    }
    return true;
}

+(NSString *) downloadCandleCSV:(NSString *)nazovRozvrhu{
    
    NSString *stringURL = [NSString stringWithFormat: @"https://candle.fmph.uniba.sk/rozvrh/%@.csv" ,nazovRozvrhu];
    NSURL  *url = [NSURL URLWithString:stringURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    
    NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"candle.csv"];
    if ( urlData )
    {
        [urlData writeToFile:filePath atomically:YES];
    }
    return filePath;
}



-(bool) getDataFromCSV:(NSString *)filePath{
    NSError *error;
    NSString *dataStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (dataStr) {        
    } else {
        DLog(@"%@",[error localizedDescription]);
        return false;
    }
    
    NSMutableArray *poleItemov = [[dataStr csvRows] mutableCopy];    
    [poleItemov removeObjectAtIndex:0];        
    self.predmety = [[NSMutableArray alloc] init];    
    
    for (NSArray *item in poleItemov)
    {
        Predmet *predm = [[Predmet alloc] init];
        NSString* den = [item objectAtIndex:0];
        NSArray *dniTyzdna = @[@"Po", @"Ut", @"Str", @"St", @"Pi"];
        int cislo = [dniTyzdna indexOfObject: den];        
        
        predm.day = [NSNumber numberWithInt: cislo];
        predm.start = [item objectAtIndex:1];
        predm.room = [item objectAtIndex:4];
        predm.name = [item objectAtIndex:6];
        cislo = (int)[[item objectAtIndex:3] characterAtIndex:0]-48;
        predm.classLength = [NSNumber numberWithInt:cislo];
        
        [self.predmety addObject:predm];
    }
    DLog(@"POLE %@",self.predmety);
    
    return true;
}


- (NSMutableArray *) getLessonsForDay:(int)den{
    NSMutableArray *pole = [[NSMutableArray alloc] init];
    for (Predmet *predm in _predmety) {
        if([predm.day integerValue]==den){
            [pole addObject:predm];
        }
    }
    return pole;
    
}



- (void) nastavUsername:(UITextField *)UIUserNameTextField{
    self.username = UIUserNameTextField.text;
}








@end
