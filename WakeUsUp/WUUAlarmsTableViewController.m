//
//  WUUAlarmsTableViewController.m
//  WakeUsUp
//
//  Created by David Cao on 9/13/14.
//  Copyright (c) 2014 David.Cao. All rights reserved.
//

#import "WUUAlarmsTableViewController.h"
#import "WUUAlarmTableViewCell.h"
#import "WUUClockViewController.h"
#import "WUUNewAlarmViewController.h"

NSString *AlarmCellIdentifier = @"AlarmCellIdentifier";

@interface WUUAlarmsTableViewController ()

- (void)createNewAlarm;
- (void)pushAlarm;

@end

@implementation WUUAlarmsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        UIBarButtonItem *addGroup = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createNewAlarm)];
        [[self navigationItem] setRightBarButtonItem:addGroup];
        
        [[self navigationItem] setTitle:@"Alarms"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self tableView] registerNib:[UINib nibWithNibName:@"WUUAlarmTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:AlarmCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushAlarm) name:@"AlarmHappening" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AlarmHappening" object:nil];
}

- (void)pushAlarm {
    
    NSLog(@"Push alarm");
    WUUClockViewController *clock = [[WUUClockViewController alloc] initWithAlarm];
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
    [self presentViewController:clock animated:NO completion:nil];
    
}

- (void)createNewAlarm {
    
    WUUNewAlarmViewController *newAlarm = [[WUUNewAlarmViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:newAlarm];
    
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WUUAlarmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AlarmCellIdentifier];
    
    if (!cell) {
        cell = [[WUUAlarmTableViewCell alloc] init];
    }
    // Configure the cell...
    
    UILabel *timeLabel = [[UILabel alloc] init];
    [timeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:43.0]];
    [timeLabel setText:@"12:30"];
    [timeLabel sizeToFit];
    [timeLabel setFrame:CGRectMake(6, 6, timeLabel.frame.size.width, timeLabel.frame.size.height)];
    [timeLabel layoutIfNeeded];
    
    UILabel *ampmLabel = [[UILabel alloc] initWithFrame:CGRectMake(10+timeLabel.frame.size.width, 31, 26, 21)];
    [ampmLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:17.0]];
    [ampmLabel setText:@"AM"];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + timeLabel.frame.size.height, 230, 21)];
    [nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:15.0]];
    [nameLabel setText:@"Swim Practice"];
    
    UIImageView *friendImageView = [[UIImageView alloc] initWithFrame:CGRectMake(245, 10, 65, 65)];
    [[friendImageView layer] setCornerRadius:32.5];
    [[friendImageView layer] setMasksToBounds:YES];
    [friendImageView setImage:[UIImage imageNamed:@"avatar_placeholer"]];
    
    
    //lol this code structure
    
    [cell addSubview:timeLabel];
    [cell addSubview:ampmLabel];
    [cell addSubview:nameLabel];
    [cell addSubview:friendImageView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"Push clock hurr");
    
    WUUClockViewController *clockController = [[WUUClockViewController alloc] init];
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
    [self presentViewController:clockController animated:NO completion:nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
