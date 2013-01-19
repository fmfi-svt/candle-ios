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
    
    ZoznamPredmetov * dbPredmetov =[[ZoznamPredmetov alloc] init];
    self.polePredmetov = [dbPredmetov getDataFromCSV];
//    [self.UInazovPredmetu setText:((Predmet *) [self.polePredmetov objectAtIndex:0]).name];
//    [self.UImiestnostPredmetu setText:((Predmet *) [self.polePredmetov objectAtIndex:0]).room];
//    [self.UIzaciatokPredmetu setText:( [((Predmet *) [self.polePredmetov objectAtIndex:0]).start stringValue] )];
    DLog(@"Array Count: %d",[self.polePredmetov count]);
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


-(int)denVTyzdni:(id)sender
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    int weekday = [comps weekday];
    gregorian=nil;
    comps=nil;
    return weekday;
}




- (void)vypisRozvrh:(id)sender
{   
    
 //   NSArray * predmety = [NSArray arrayWithObjects: @"telesna", @"matematika", @"pocitace", nil];
  //  NSMutableArray *array = [NSMutableArray arrayWithObjects: @"one", @"two", @"three", @"four", nil];
  
  //   NSString *tempPredmet;
    
   // for (NSString * str in self.polePredmetov) {
       // tempPredmet = [NSString stringWithFormat:@"%@, %@", self.polePredmetov, str];
       // tempPredmety = [tempPredmety stringByAppendingString:str];
  //  }
//    rozvrhLabel.text = tempPredmet;
    static NSInteger currentIndex = 0;
    if (++currentIndex == [self.polePredmetov count]) {
        currentIndex=0;
    }else{
        //[UItabulkaRozvrh cellForRowAtIndexPath:];
  //      Predmet *predmet = (Predmet *) [self.polePredmetov objectAtIndex: currentIndex];
 //       [self.UInazovPredmetu setText:predmet.name];
 //       [self.UImiestnostPredmetu setText:predmet.room];
 //       [self.UIzaciatokPredmetu setText:[predmet.start stringValue]];
    }
    
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
    cell.textLabel.text = [NSString stringWithFormat:@"%@-%@ (%@)",predm.start,predm.name,predm.room];
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