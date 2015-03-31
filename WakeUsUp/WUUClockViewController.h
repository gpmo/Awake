//
//  WUUClockViewController.h
//  WakeUsUp
//
//  Created by David Cao on 9/13/14.
//  Copyright (c) 2014 David.Cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WUUClockViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *hoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *colonLabel;
@property (weak, nonatomic) IBOutlet UILabel *minutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *ampmLabel;
@property (weak, nonatomic) IBOutlet UIButton *snoozeButton;
@property (weak, nonatomic) IBOutlet UIButton *endButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

- (IBAction)close:(id)sender;
- (IBAction)snooze:(id)sender;
- (IBAction)end:(id)sender;

- (id)initWithAlarm;

@end
