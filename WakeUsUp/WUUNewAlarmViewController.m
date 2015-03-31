//
//  WUUNewAlarmViewController.m
//  WakeUsUp
//
//  Created by David Cao on 9/14/14.
//  Copyright (c) 2014 David.Cao. All rights reserved.
//

#import "WUUNewAlarmViewController.h"
#import "WUUContactPickerViewController.h"
#import "WUUConnectionManager.h"

BOOL keyboardIsShown = NO;
NSString *NewAlarmCellIdentifier = @"NewAlarmCellIdentifier";

@interface WUUNewAlarmViewController () <UITextFieldDelegate>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) UITextField *nameField;

- (void)save;
- (void)cancel;
- (void)dismissKeyboard;

- (void)keyboardWillHide:(NSNotification *)n;
- (void)keyboardWillShow:(NSNotification *)n;

@end

@implementation WUUNewAlarmViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
        UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
        
        [[self navigationItem] setLeftBarButtonItem:cancel];
        [[self navigationItem] setRightBarButtonItem:save];
        [[self navigationItem] setTitle:@"New Alarm"];
        
        [self setFriends:[NSMutableArray array]];
        [self setFriendIndexes:[NSMutableArray array]];
        [self setName:@"Alarm"];
        [self setNameField:[[UITextField alloc] init]];
        [[self nameField] setDelegate:self];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
        [[self view] addGestureRecognizer:tapGesture];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    //keyboard scrolling shit from githubby
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    keyboardIsShown = NO;
    //make contentSize bigger than your scrollSize (you will need to figure out for your own use case)
    CGSize scrollContentSize = CGSizeMake(320, 345);
    self.scrollView.contentSize = scrollContentSize;
    
}

- (void)keyboardWillHide:(NSNotification *)n
{
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    // resize the scrollview
    CGRect viewFrame = self.scrollView.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrame.size.height += (keyboardSize.height);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.scrollView setFrame:viewFrame];
    [UIView commitAnimations];
    
    keyboardIsShown = NO;
}

- (void)keyboardWillShow:(NSNotification *)n
{
    // This is an ivar I'm using to ensure that we do not do the frame size adjustment on the `UIScrollView` if the keyboard is already shown.  This can happen if the user, after fixing editing a `UITextField`, scrolls the resized `UIScrollView` to another `UITextField` and attempts to edit the next `UITextField`.  If we were to resize the `UIScrollView` again, it would be disastrous.  NOTE: The keyboard notification will fire even when the keyboard is already shown.
    if (keyboardIsShown) {
        return;
    }
    
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // resize the noteView
    CGRect viewFrame = self.scrollView.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrame.size.height -= (keyboardSize.height);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.scrollView setFrame:viewFrame];
    [UIView commitAnimations];
    keyboardIsShown = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [[self tableView] reloadData];
    NSLog(@"Selected: %@", [self friendIndexes]);
}

- (void)dismissKeyboard {
    [[self nameField] resignFirstResponder];
}

- (void)save {
    
    NSDate *currentDate = [NSDate date];
    NSDate *date = [[self datePicker] date];
    NSInteger totalSeconds = [date timeIntervalSinceReferenceDate];
    NSTimeInterval seconds = totalSeconds % 60;
    date = [date dateByAddingTimeInterval:-seconds];
    
    if ([date timeIntervalSinceDate:currentDate] < 0) {
        date = [date dateByAddingTimeInterval:86400];
    }
    NSLog(@"Date chosen: %@", date);
    NSLog(@"Friends chosen: %@", [self friends]);
    NSLog(@"Label: %@", [self name]);
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    [notification setFireDate:date];
    [notification setTimeZone:[NSTimeZone defaultTimeZone]];
    [notification setAlertBody:[self name]];
    [notification setAlertAction:@"snooze or end"];
    [notification setSoundName:@"digital_alarm.wav"];
    
//    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    NSMutableArray *phones = [NSMutableArray array];
    for (NSDictionary *dict in [self friends]) {
        [phones addObject:[dict objectForKey:@"number"]];
    }
    
    [WUUConnectionManager createGroup:phones description:[self name] time:date];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancel {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addFriends:(id)sender {
    
    WUUContactPickerViewController *contactPicker = [[WUUContactPickerViewController alloc] initWithNewAlarmController:self];
    
    [contactPicker setSelected:[NSMutableArray arrayWithArray:[self friendIndexes]]];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:contactPicker];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    [self setName:[[textField text] stringByReplacingCharactersInRange:range withString:string]];
    
    return YES;
}

#pragma mark - TableView stuffs

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    } else {
        if ([[self friends] count] == 0) {
            return 1;
        }
        return [[self friends] count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return @"Label";
    } else {
        return @"Friends";
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NewAlarmCellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    // Configure the cell...
    
    if ([indexPath section] == 0) {
        
        UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:NewAlarmCellIdentifier];
        
        if (!cell2) {
            cell2 = [[UITableViewCell alloc] init];
        }
        
        [[self nameField] setFrame:CGRectMake(20, 0, cell2.frame.size.width - 20, cell2.frame.size.height)];
        [[self nameField] setDelegate:self];
        [[self nameField] setClearButtonMode:UITextFieldViewModeWhileEditing];
        [[self nameField] setText:[self name]];
        [cell2 addSubview:[self nameField]];
        
        return cell2;
    } else {
        
        
        if ([[self friends] count] == 0) {
            [[cell textLabel] setText:@"No friends added yet."];
        } else {
            NSDictionary *dict = [[self friends] objectAtIndex:[indexPath row]];
            [[cell textLabel] setText:[NSString stringWithFormat:@"%@ %@", [dict objectForKey:@"first"], [dict objectForKey:@"last"]]];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

@end
