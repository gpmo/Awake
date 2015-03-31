//
//  PHLReadContext.m
//  iPhillipian
//
//  Created by David Cao on 7/16/14.
//  Copyright (c) 2014 Phillipian. All rights reserved.
//

#import "WUUMainContext.h"
#import "WUUPSCManager.h"

static WUUMainContext *sharedReadContextManager = nil;

@interface WUUMainContext ()

@property (strong, nonatomic) NSManagedObjectContext *src;
@end



@implementation WUUMainContext
@synthesize src;

+ (id)allocWithZone:(NSZone *)zone{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedReadContextManager = [[super allocWithZone:nil] init];
    });
    
    return sharedReadContextManager;
}

+ (NSManagedObjectContext *)sharedContext{
    if (!sharedReadContextManager) {
        sharedReadContextManager = [[WUUMainContext alloc] init];
    }
    if ([sharedReadContextManager src]) {
        return [sharedReadContextManager src];
    }
    
    NSPersistentStoreCoordinator *psc = [WUUPSCManager sharedStoreCooridinator];
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [moc setPersistentStoreCoordinator:psc];
    
    [sharedReadContextManager setSrc:moc];
    
    return [sharedReadContextManager src];
}

@end
