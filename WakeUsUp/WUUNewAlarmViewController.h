//
//  WUUNewAlarmViewController.h
//  WakeUsUp
//
//  Created by David Cao on 9/14/14.
//  Copyright (c) 2014 David.Cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WUUNewAlarmViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSMutableArray *friends;
@property (nonatomic) NSMutableArray *friendIndexes;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)addFriends:(id)sender;

@end
