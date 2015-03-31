//
//  WUUContactPickerViewController.h
//  WakeUsUp
//
//  Created by David Cao on 9/13/14.
//  Copyright (c) 2014 David.Cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WUUNewAlarmViewController;

@interface WUUContactPickerViewController : UITableViewController

@property (strong, nonatomic) WUUNewAlarmViewController *createAlarmController;
@property (strong, nonatomic) NSMutableArray *selected;

- (id)initWithNewAlarmController:(WUUNewAlarmViewController *)controller;

@end
