//
//  WUUDesignHelper.m
//  WakeUsUp
//
//  Created by David Cao on 9/13/14.
//  Copyright (c) 2014 David.Cao. All rights reserved.
//

#import "WUUDesignHelper.h"

@implementation WUUDesignHelper

+ (void)setupAppearance {
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:26.0/255.0 green:161.0/255.0 blue:1 alpha:1.0]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                           NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:24.0]}];
    
}

@end
