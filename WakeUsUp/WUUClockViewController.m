//
//  WUUClockViewController.m
//  WakeUsUp
//
//  Created by David Cao on 9/13/14.
//  Copyright (c) 2014 David.Cao. All rights reserved.
//

#import "WUUClockViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface WUUClockViewController () {
    SystemSoundID alarmSound;
}

@property BOOL run;
@property BOOL playSound;
@property BOOL alarmHappening;
@property AVAudioPlayer *player;

- (void)updateClock;
- (void)playAlarm;

- (void)start;
- (void)notify;

@end

@implementation WUUClockViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setRun:YES];
        [self setPlaySound:NO];
        [self setAlarmHappening:NO];
    }
    return self;
}

- (id)initWithAlarm {
    
    if (self = [super init]) {
        // Custom initialization
        [self setRun:YES];
        [self setPlaySound:YES];
        [self setAlarmHappening:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notify) name:@"AlarmHappening" object:nil];
    
    [self updateClock];
    
    
    NSURL *soundURL   = [[NSBundle mainBundle] URLForResource: @"digital_alarm" withExtension: @"wav"];

    //initialize SystemSounID variable with file URL
    AudioServicesCreateSystemSoundID(CFBridgingRetain(soundURL), &alarmSound);
    
    [[AVAudioSession sharedInstance]
     setCategory: AVAudioSessionCategoryPlayback
     error: nil];
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
    
    [self start];
}

- (void)notify {
    
    NSLog(@"notification");
    [self setAlarmHappening:YES];
    [self setPlaySound:YES];
    [self start];
    
}

- (void)start {
    if ([self playSound]) {
        [self playAlarm];
    }

    if ([self alarmHappening]) {
        [[self closeButton] setHidden:YES];
        [[self snoozeButton] setHidden:NO];
        [[self endButton] setHidden:NO];
    } else {
        [[self closeButton] setHidden:NO];
        [[self snoozeButton] setHidden:YES];
        [[self endButton] setHidden:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [[[self navigationController] navigationBar] setHidden:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self setRun:NO];
    [self setPlaySound:NO];
    [self setPlayer:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AlarmHappening" object:nil];
}

- (void)playAlarm {
    
    [self.player play];
    
    if ([self playSound]) {
        [self performSelector:@selector(playAlarm) withObject:self afterDelay:35.0];
    }
}

- (void)updateClock {
    
    NSDateFormatter *clockFormat = [[NSDateFormatter alloc] init];
    [clockFormat setDateFormat:@"h:mm:ss a"];
    
    NSLog(@"%@", [clockFormat stringFromDate:[NSDate date]]);
    
    NSString *stringDate = [clockFormat stringFromDate:[NSDate date]];

    NSInteger colon1 = [stringDate rangeOfString:@":"].location;
    
    //if we ever want seconds
//    NSInteger colon2 = [stringDate rangeOfString:@":" options:NSBackwardsSearch].location;
    
    NSString *hours = [stringDate substringToIndex:colon1];
    NSString *minutes = [stringDate substringWithRange:NSMakeRange(colon1 + 1, 2)];
    NSString *ampm = [stringDate substringFromIndex:([stringDate length] - 2)];
    
    [[self hoursLabel] setText:hours];
    [[self minutesLabel] setText:minutes];
    [[self ampmLabel] setText:ampm];
    
    if ([self run]) {
        [self performSelector:@selector(updateClock) withObject:self afterDelay:1.0];
    }
}

- (IBAction)close:(id)sender {
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

- (IBAction)snooze:(id)sender {
    
    NSLog(@"snooze");
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    [notification setFireDate:[[NSDate date] dateByAddingTimeInterval:300]];
    [notification setTimeZone:[NSTimeZone defaultTimeZone]];
    [notification setAlertBody:@"Snoozing"];
    [notification setAlertAction:@"snooze or end"];
    [notification setSoundName:@"digital_alarm.wav"];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)end:(id)sender {
    
    NSLog(@"End");
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
