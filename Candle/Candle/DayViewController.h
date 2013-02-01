//
//  FirstViewController.h
//  Candle
//
//  Created by Peter Sulik on 10/30/12.
//  Copyright (c) 2012 Peter Sulik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DayViewController : UIViewController<UITableViewDelegate , UITableViewDataSource>
 {

}


@property(nonatomic,retain) NSMutableArray *polePredmetov;
@property (nonatomic, retain) IBOutlet UILabel *UILabelDen;
@property (nonatomic, retain) IBOutlet UILabel *UILabelUsername;
@property (nonatomic, retain) IBOutlet UITableView *UItabulkaRozvrh;


- (NSNumber *) denVTyzdni;



- (IBAction)backgroundTouchedHideKeyboard:(id)sender;
@end

