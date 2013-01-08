//
//  FirstViewController.h
//  Candle
//
//  Created by Peter Sulik on 10/30/12.
//  Copyright (c) 2012 Peter Sulik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController {
    NSMutableArray *polePredmetov;
    
    UITextField *tempTextBox;
    UILabel     *rozvrhLabel;
    UITableView *tabulkaRozvrh;
}


@property(nonatomic,retain) NSMutableArray *polePredmetov;

@property (weak, nonatomic) IBOutlet UILabel *UInazovPredmetu;
@property (weak, nonatomic) IBOutlet UILabel *UImiestnostPredmetu;
@property (weak, nonatomic) IBOutlet UILabel *UIzaciatokPredmetu;

- (IBAction)vypisPredmet:(id)sender;



@property (nonatomic, retain) IBOutlet UILabel *rozvrhLabel;
@property (nonatomic, retain) IBOutlet UITextField *candleNameTextBox;
@property (nonatomic, retain) IBOutlet UITableView *tabulkaRozvrh;


- (IBAction)vypisRozvrh:(id)sender;
- (IBAction)backgroundTouchedHideKeyboard:(id)sender;
@end

