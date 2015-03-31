//
//  WUUConnectionManager.h
//  WakeUsUp
//
//  Created by David Cao on 9/14/14.
//  Copyright (c) 2014 David.Cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WUUConnectionManager : NSObject

+ (BOOL)login:(NSString *)phone password:(NSString *)password;
+ (void)createAccount:(NSString *)first last:(NSString *)last phone:(NSString *)phone password:(NSString *)password;
+ (void)createGroup:(NSArray *)users description:(NSString *)descrp time:(NSDate *)alarm;
+ (void)updateAlarmState:(NSString *)groupID phone:(NSString *)phone state:(NSNumber *)state;
+ (void)toggleAlarm:(NSString *)groupID phone:(NSString *)phone;

@end