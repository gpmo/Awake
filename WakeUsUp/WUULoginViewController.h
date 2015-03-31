//
//  WUULoginViewController.h
//  WakeUsUp
//
//  Created by David Cao on 9/13/14.
//  Copyright (c) 2014 David.Cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WUULoginViewController : UIViewController

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UIView *fieldView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)submit:(id)sender;
- (IBAction)signUp:(id)sender;

@end
