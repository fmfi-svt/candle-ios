//
//  DBManager.h
//  Candle
//
//  Created by Pejko Salik on 6/21/13.
//  Copyright (c) 2013 Peter Sulik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Database.h"
@interface DBManager : NSObject
{
    NSString *databasePath;
    Database *database;
    
}


+(DBManager*)getSharedInstance;
-(BOOL)createDB;
-(BOOL) saveData:(NSString*)registerNumber name:(NSString*)name
      department:(NSString*)department year:(NSString*)year;
-(NSArray*) findByRegisterNumber:(NSString*)registerNumber;

@end
