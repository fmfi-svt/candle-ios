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

- (void)viewDidLoad{
    NSArray *dniTyzdna = @[@"Nedela", @"Pondelok", @"Utorok", @"Streda", @"Stvrtok", @"Piatok", @"Sobota"];
    NSNumber *den= [self denVTyzdni];
    
    self.UILabelDen.text = [dniTyzdna objectAtIndex: [den intValue]];
    NSError *error;
    ZoznamPredmetov * zoznamPredmetov = [ZoznamPredmetov zoznamPredmetovWithDefaultURLandNick:@"sulo" AndWithError:&error];
    if(zoznamPredmetov){
        self.polePredmetov = [zoznamPredmetov getLessonsForDay:[den intValue]];
        self.UILabelUsername.text = [zoznamPredmetov username];
    } else {
        UIAlertView *errorView;
        errorView = [[UIAlertView alloc]
                     initWithTitle: NSLocalizedString(@"Network error", @"Network error")
                     message: [error localizedDescription]
                     delegate: self
                     cancelButtonTitle: NSLocalizedString(@"Close", @"Network error") otherButtonTitles: nil];
        
        [errorView show];
    }    
    [super viewDidLoad];
}

-(NSNumber *) denVTyzdni
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    int c = [comps weekday]-1;
    
    NSNumber *weekday = [NSNumber numberWithInt:c];
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

- (void)backgroundTouchedHideKeyboard:(id)sender{
    //    [tempTextBox resignFirstResponder];
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload{
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