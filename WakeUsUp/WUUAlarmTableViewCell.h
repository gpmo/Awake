//
//  WUUAlarmTableViewCell.h
//  WakeUsUp
//
//  Created by David Cao on 9/13/14.
//  Copyright (c) 2014 David.Cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WUUAlarmTableViewCell : UITableViewCell
@property (weak, nonatomic) UILabel *timeLabel;
@property (weak, nonatomic) UILabel *ampmLabel;
@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UIImageView *friendImageView;

@end
