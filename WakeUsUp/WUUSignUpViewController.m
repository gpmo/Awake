//
//  WUUSignUpViewController.m
//  WakeUsUp
//
//  Created by David Cao on 9/13/14.
//  Copyright (c) 2014 David.Cao. All rights reserved.
//

#import "WUUSignUpViewController.h"
#import "WUULoginViewController.h"
#import "WUUConnectionManager.h"

@interface WUUSignUpViewController ()

- (void)dismissKeyboard;

@end

@implementation WUUSignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
        [[self view] addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)dismissKeyboard {
    
    [[self firstField] resignFirstResponder];
    [[self lastField] resignFirstResponder];
    [[self phoneField] resignFirstResponder];
    [[self passwordField] resignFirstResponder];
    [[self confirmPasswordField] resignFirstResponder];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[[self fieldView] layer] setCornerRadius:8.0];
    [[[self submitButton] layer] setCornerRadius:8.0];
    
}

- (IBAction)next:(id)sender {

    if ([[[self firstField] text] length] == 0 || [[[self lastField] text] length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Name" message:@"Come on, you've got to have a name." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [WUUConnectionManager createAccount:[[self firstField] text] last:self.lastField.text phone:self.phoneField.text password:self.passwordField.text];
    
}

- (IBAction)close:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
