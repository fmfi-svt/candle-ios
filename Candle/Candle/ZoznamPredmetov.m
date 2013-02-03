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


+ (id) zoznamPredmetovWithURL: (NSString *)nick {
    ZoznamPredmetov *zp = [[self alloc] init];
    if ([zp checkConnection]) {
        [zp getDataFromCSV:[zp downloadCandleCSV:nick]];
    } else {
        UIAlertView *errorView;
        errorView = [[UIAlertView alloc]
                     initWithTitle: NSLocalizedString(@"Network error", @"Network error")
                     message: NSLocalizedString(@"No internet connection found, this application requires an internet connection to gather the data required.", @"Network error")
                     delegate: self
                     cancelButtonTitle: NSLocalizedString(@"Close", @"Network error") otherButtonTitles: nil];
        
        [errorView show];
        
        
    }

    return zp;
}




-(bool) checkConnection{
    
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if(internetStatus == NotReachable) {
        
        
        return false;
    }
    return true;
}



-(NSString *) downloadCandleCSV:(NSString *)nazovRozvrhu{
    
    
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



-(NSMutableArray *) getDataFromCSV:(NSString *)filePath{
    
    
    NSError *error;
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString  *documentsDirectory = [paths objectAtIndex:0];
//    NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"candle.csv"];
    
    NSString *dataStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (dataStr) {
        
    } else {
        DLog(@"%@",[error localizedDescription]);
    }
    
    NSArray *poleItemov = [dataStr csvRows];
    
    
    int i=0;
    int cislo =0;
    NSMutableArray *pole = [[NSMutableArray alloc] init];
    _predmety = [[NSMutableArray alloc] init];
    
    for (NSArray *item in poleItemov) {
        if (i>0) {
            Predmet *predm = [[Predmet alloc] init];
            
            NSString* den = [item objectAtIndex:0];
            
            if([den isEqualToString:@"Po"]){ cislo=0; } else
                if([den isEqualToString:@"Ut"]){ cislo=1; } else
                    if([den isEqualToString:@"Str"]){ cislo=2; } else
                        if([den isEqualToString:@"St"]){ cislo=3; } else
                            if([den isEqualToString:@"Pi"]){ cislo=4; }
            
            
            predm.day = [NSNumber numberWithInt: cislo];
            predm.start = [item objectAtIndex:1];
            predm.room = [item objectAtIndex:4];
            predm.name = [item objectAtIndex:6];
            cislo = (int)[[item objectAtIndex:3] characterAtIndex:0]-48;
            predm.classLength = [NSNumber numberWithInt:cislo];
            
            [pole addObject:predm];
            [_predmety addObject:predm];
        }
        
        i++;
    }
    DLog(@"POLE %@",_predmety);
    
    return pole;
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



- (void) nastavUsername:(UITextField *)UIUserNameTextField;
{
    self.username = UIUserNameTextField.text;
}








@end
