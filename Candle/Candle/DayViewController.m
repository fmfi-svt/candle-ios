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
    NSArray *dniTyzdna = [NSArray arrayWithObjects:@"Pondelok", @"Utorok", @"Streda", @"Stvrtok", @"Piatok", @"Sobota", @"Nedela",nil];
    int c= [self denVTyzdni];
    DLog(@"==== %d",c);
    
    _UILabelDen.text = [dniTyzdna objectAtIndex: [self denVTyzdni]];
    ZoznamPredmetov * dbPredmetov =[[ZoznamPredmetov alloc] init];
//    dbPredmetov.username = @"jakubko";
    dbPredmetov.username = @"sulo";    
    [dbPredmetov getDataFromCSV];
    self.polePredmetov = [dbPredmetov getLessonsForDay:c];

    _UILabelUsername.text = [dbPredmetov username];
    
    [super viewDidLoad];
    
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)vypisPredmet:(id)sender
{
//    static NSInteger currentIndex = 0;
//    if (++currentIndex == [self.polePredmetov count]) {
//        currentIndex=0;
//    }else{
//        Predmet *predmet = (Predmet *) [self.polePredmetov objectAtIndex: currentIndex];
//        [self.UInazovPredmetu setText:predmet.name];
//        [self.UImiestnostPredmetu setText:predmet.room];
//        [self.UIzaciatokPredmetu setText:[predmet.start stringValue]];
//}
}


-(int) denVTyzdni
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];   
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
   
    int weekday = [comps weekday];
    gregorian=nil;
    comps=nil;
    return weekday-2;
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
     
//-(IBAction)addLesson:(id)sender
//{
//    [UItabulkaRozvrh beginUpdates];
//    [polePredmetov addObject:@"Lesson"];
//    //NSArray *paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:[polePredmetov count]-1 inSection:1]];
//    [[self UItabulkaRozvrh] insertRowsAtIndexPaths:polePredmetov withRowAnimation:UITableViewRowAnimationTop];
//    [UItabulkaRozvrh endUpdates];
//}


- (void)backgroundTouchedHideKeyboard:(id)sender
{
    //    [tempTextBox resignFirstResponder];
}



- (void)viewDidUnload
{
    
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.polePredmetov =nil;
    //    self.UInazovPredmetu = nil;
    //    self.UImiestnostPredmetu = nil;
    //    self.UIzaciatokPredmetu = nil;
    self.UItabulkaRozvrh = nil;
    //    self.candleNameTextBox = nil;
    //    self.rozvrhLabel = nil;
    [super viewDidUnload];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Row pressed!!");
}

@end