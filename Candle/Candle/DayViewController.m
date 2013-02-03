//
//  FirstViewController.m
//  Candle
//
//  Created by Peter Sulik on 10/30/12.
//  Copyright (c) 2012 Peter Sulik. All rights reserved.
//

#import "DayViewController.h"
#import "Predmet.h"
#import "ZoznamPredmetov.h"



@interface DayViewController ()
@end


@implementation DayViewController

- (void)viewDidLoad
{
    NSArray *dniTyzdna = @[@"Pondelok", @"Utorok", @"Streda", @"Stvrtok", @"Piatok", @"Sobota", @"Nedela"];
    NSNumber *den= [self denVTyzdni];
    
    self.UILabelDen.text = [dniTyzdna objectAtIndex: [den intValue]];
    ZoznamPredmetov * dbPredmetov =[[ZoznamPredmetov alloc] init];
    dbPredmetov.username = @"sulo";
    
    if([dbPredmetov checkConnection]){
        [dbPredmetov downloadCandleCSV:dbPredmetov.username];        
    } else {
        UIAlertView *errorView;        
        errorView = [[UIAlertView alloc]
                     initWithTitle: NSLocalizedString(@"Network error", @"Network error")
                     message: NSLocalizedString(@"No internet connection found, this application requires an internet connection to gather the data required.", @"Network error")
                     delegate: self
                     cancelButtonTitle: NSLocalizedString(@"Close", @"Network error") otherButtonTitles: nil];
        
        [errorView show];
        
        
    }
    
    
    [dbPredmetov getDataFromCSV:dbPredmetov.username];
    
    self.polePredmetov = [dbPredmetov getLessonsForDay:[den intValue]];

    self.UILabelUsername.text = [dbPredmetov username];
    
    [super viewDidLoad];
    
	
}


-(NSNumber *) denVTyzdni
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];   
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
   
    NSNumber *weekday = [NSNumber numberWithInt:[comps weekday]-2];
    gregorian=nil;
    comps=nil;
    return weekday;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.polePredmetov count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier];
        
    }
    
    // Set up the cell...
    Predmet *predm = [self.polePredmetov objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"[%@]%@ (%@)",predm.start,predm.name,predm.room];
    DLog(@"Cell is %@", predm.name);
    return cell;

     }


- (void)backgroundTouchedHideKeyboard:(id)sender
{
    //    [tempTextBox resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)viewDidUnload
{
    
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.polePredmetov =nil;
    self.UItabulkaRozvrh = nil;

    [super viewDidUnload];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Row pressed!!");
}

@end