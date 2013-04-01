//
//  XMLHandler.m
//  Candle
//
//  Created by Pejko Salik on 4/1/13.
//  Copyright (c) 2013 Peter Sulik. All rights reserved.
//

#import "XMLHandler.h"

@implementation XMLHandler

+ (BOOL)downloadXMLFromUrl:(NSURL*) url{
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if ( urlData )
    {
        [urlData writeToFile:[XMLHandler downloadedXMLFilePath] atomically:YES];
        return YES;
    }
    return NO;
}

+ (NSString *) downloadedXMLFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    return [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"rozvrh.xml"];
}

+ (BOOL)checkForNewerXML:(NSURL *)url{
    return YES;
}

+ (void)parseXML:(NSString *)fileName{
    NSError *error;
    TBXML * tbxml = [TBXML newTBXMLWithXMLFile:[XMLHandler downloadedXMLFilePath] error:&error];
    
    if (error) {
        NSLog(@"%@ %@", [error localizedDescription], [error userInfo]);
    } else {
        NSLog(@"%@", [TBXML elementName:tbxml.rootXMLElement]);
    }
    
    //tu treba vymysliet, nejaku vhodnu formu uskladnovania dat z xml
}

+ (void) traverseElement:(TBXMLElement *)element {
    do {
        // Display the name of the element
        NSLog(@"%@",[TBXML elementName:element]);
        
        // Obtain first attribute from element
        TBXMLAttribute * attribute = element->firstAttribute;
        
        // if attribute is valid
        while (attribute) {
            // Display name and value of attribute to the log window
            NSLog(@"%@->%@ = %@",  [TBXML elementName:element],
                  [TBXML attributeName:attribute],
                  [TBXML attributeValue:attribute]);
            
            // Obtain the next attribute
            attribute = attribute->next;
        }
        
        // if the element has child elements, process them
        if (element->firstChild)
            [self traverseElement:element->firstChild];
        
        // Obtain next sibling element
    } while ((element = element->nextSibling));  
}


@end
