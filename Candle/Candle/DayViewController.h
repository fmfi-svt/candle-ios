//
//  FirstViewController.h
//  Candle
//
//  Created by Peter Sulik on 10/30/12.
//  Copyright (c) 2012 Peter Sulik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DayViewController : UIViewController {
    NSMutableArray *polePredmetov;
    UILabel     *UILabelDen;
    UITableView *UItabulkaRozvrh;
}


@property(nonatomic,retain) NSMutableArray *polePredmetov;

@property (nonatomic, retain) IBOutlet UILabel *UILabelDen;
@property (nonatomic, retain) IBOutlet UITableView *UItabulkaRozvrh;

- (IBAction)vypisPredmet:(id)sender;
- (int) denVTyzdni:(id)sender;
- (IBAction)vypisRozvrh:(id)sender;



- (IBAction)backgroundTouchedHideKeyboard:(id)sender;
@end

