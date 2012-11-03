//
//  FirstViewController.h
//  Candle
//
//  Created by Pejko Salik on 10/30/12.
//  Copyright (c) 2012 Pejko Salik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController {
    UITextField *tempTextBox;
    UILabel     *rozvrhLabel;
    UITableView *tabulkaRozvrh;
}
@property (nonatomic, retain) IBOutlet UILabel *rozvrhLabel;
@property (nonatomic, retain) IBOutlet UITextField *candleNameTextBox;
@property (nonatomic, retain) IBOutlet UITableView *tabulkaRozvrh;

- (IBAction)degreeConvert:(id)sender;
- (IBAction)writeRozvrh:(id)sender;
- (IBAction)backgroundTouchedHideKeyboard:(id)sender;
@end

