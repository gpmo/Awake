//
//  WUUConnectionManager.m
//  WakeUsUp
//
//  Created by David Cao on 9/14/14.
//  Copyright (c) 2014 David.Cao. All rights reserved.
//

#import "WUUConnectionManager.h"

NSString *host = @"http://infinite-caverns-7266.herokuapp.com/";

@implementation WUUConnectionManager

+ (void)createGroup:(NSArray *)users description:(NSString *)descrp time:(NSDate *)alarm {
    
    NSString *listOfUsers = @"";
    for (NSString *s in users) {
        listOfUsers = [NSString stringWithFormat:@"%@+%@", listOfUsers, s];
    }
    NSLog(@"List: %@", [listOfUsers substringFromIndex:1]);
    
    NSDateFormatter *clockFormat = [[NSDateFormatter alloc] init];
    [clockFormat setDateFormat:@"ddhhmm"];
    NSString *alarmTime = [clockFormat stringFromDate:alarm];
    NSLog(@"%@", alarmTime);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@createGroup?users_list=%@&description=%@&alarm_time=%@", host, [listOfUsers substringFromIndex:1], descrp, alarmTime]];
    
    NSLog(@"url: %@", url);
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
    [req setHTTPMethod:@"POST"];
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSLog(@"Data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
    }];
    
}

+ (void)createAccount:(NSString *)first last:(NSString *)last phone:(NSString *)phone password:(NSString *)password {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@createAccount?first_name=%@&last_name=%@&phone_num=%@&password=%@", host, first, last, phone, password]];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
    [req setHTTPMethod:@"POST"];
    NSURLResponse *response;
    NSError *err = nil;
    
    [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&err];
    
    NSLog(@"Response: %@", response);
    
}

+ (BOOL)login:(NSString *)phone password:(NSString *)password {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@login?phone_num=%@&password=%@", host, phone, password]];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
    [req setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSLog(@"Data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
    }];
    
    return YES;
}

+ (void)updateAlarmState:(NSString *)groupID phone:(NSString *)phone state:(NSNumber *)state {
    
    
    
}

+ (void)toggleAlarm:(NSString *)groupID phone:(NSString *)phone {
    
    
}

@end
