//
//  WUULoginViewController.m
//  WakeUsUp
//
//  Created by David Cao on 9/13/14.
//  Copyright (c) 2014 David.Cao. All rights reserved.
//

#import "WUULoginViewController.h"
#import "WUUSignUpViewController.h"
#import "WUUAlarmsTableViewController.h"

@interface WUULoginViewController () <UITextFieldDelegate>

- (void)dismissKeyboard;

@end

@implementation WUULoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
        [[self view] addGestureRecognizer:tapGesture];
        
        [[self usernameField] setDelegate:self];
        [[self passwordField] setDelegate:self];
        
    }
    return self;
}

- (void)dismissKeyboard {
    
    [[self usernameField] resignFirstResponder];
    [[self passwordField] resignFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)viewDidLoad {
    
    [[[self fieldView] layer] setCornerRadius:8.0];
    [[[self loginButton] layer] setCornerRadius:8.0];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == [self usernameField]) {
        [[self passwordField] becomeFirstResponder];
    } else if (textField == [self passwordField]) {
        [self performSelector:@selector(submit:) withObject:self];
    }
    return YES;
}

- (IBAction)submit:(id)sender {
    
    if ([[[self usernameField] text] length] > 0) {
        
        WUUAlarmsTableViewController *alarmController = [[WUUAlarmsTableViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:alarmController];
        CATransition* transition = [CATransition animation];
        transition.duration = 0.45;
        transition.type = kCATransitionReveal;
        transition.subtype = kCATransitionFromBottom;
        [self.view.window.layer addAnimation:transition forKey:kCATransition];
        [self presentViewController:nav animated:NO completion:nil];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter a valid username" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}

- (IBAction)signUp:(id)sender {
    
    WUUSignUpViewController *signupController = [[WUUSignUpViewController alloc] init];
    [self presentViewController:signupController animated:YES completion:nil];
    
}
@end
