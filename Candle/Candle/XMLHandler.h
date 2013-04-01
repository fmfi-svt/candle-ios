//
//  XMLHandler.h
//  Candle
//
//  Created by Pejko Salik on 4/1/13.
//  Copyright (c) 2013 Peter Sulik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"

@interface XMLHandler : NSObject

+ (BOOL)downloadXMLFromUrl:(NSURL*) url;
+ (BOOL)checkForNewerXML:(NSURL *)url;
+ (NSString *) downloadedXMLFilePath;
+ (void)parseXML:(NSString *)fileName;
+ (void) traverseElement:(TBXMLElement *)element;
    


@end
