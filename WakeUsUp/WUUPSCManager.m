//
//  PHLPSCManager.m
//  iPhillipian
//
//  Created by David Cao on 7/16/14.
//  Copyright (c) 2014 Phillipian. All rights reserved.
//

 


#import "WUUPSCManager.h"
#import "WUUMainContext.h"

static NSString * const ModelURLString = @"DataModel";
static NSString * const StoreURLString = @"WakeUsUpDataModelPersistentStore.sqlite";


@interface WUUPSCManager ()

@property (strong, nonatomic) __block NSPersistentStoreCoordinator *sharedPersistentStoreCooridinator;

- (void)initializePersistentStore;
- (NSURL *)storeURL;
- (NSURL *)storeURLSHM;
- (NSURL *)storeURLWAL;

@end

@implementation WUUPSCManager
@synthesize sharedPersistentStoreCooridinator = _sharedPersistentStoreCooridinator;
@synthesize mom = _mom;

- (id)init{
    
    
    if (self = [super init]) {
        [self initializePersistentStore];
    }
    return self;
}


+(id)allocWithZone:(NSZone *)zone{
    return [self sharedManager];
}


+ (id)sharedManager{
    static WUUPSCManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[super allocWithZone:nil] init];
    });
    
    return sharedManager;
}


+(NSPersistentStoreCoordinator *)sharedStoreCooridinator{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [WUUPSCManager sharedManager];

    });

    return [[WUUPSCManager sharedManager] sharedPersistentStoreCooridinator];
}


- (void)initializePersistentStore{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:ModelURLString
                                              withExtension:@"momd"];
    __block NSURL *storeURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                              inDomains:NSUserDomainMask] lastObject];
    storeURL = [storeURL URLByAppendingPathComponent:StoreURLString];
    
    NSManagedObjectModel *theMom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    _mom = theMom;
    
#ifdef DEBUG
    NSAssert(_mom, @"managed object model failed");
#endif
    
    [self setSharedPersistentStoreCooridinator:[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:theMom]];
 
    NSError *error = nil;
    
    
    NSDictionary *options = @{NSInferMappingModelAutomaticallyOption: @YES,NSMigratePersistentStoresAutomaticallyOption: @YES};
    
    NSLog(@"Persistent store URL: %@", storeURL);
    
    [[self sharedPersistentStoreCooridinator] addPersistentStoreWithType:NSSQLiteStoreType
                                                               configuration:nil
                                                                         URL:storeURL
                                                                     options:options
                                                                       error:&error];
    SharedErrorBlock(error, METHOD_NAME);
}


//---------FOR DEVELOPMENT USE ONLY!!!!---------

- (void)purgeData{
    NSError *err = nil;
    NSPersistentStore *persistentStore = [[[self sharedPersistentStoreCooridinator] persistentStores] objectAtIndex:0];
    [[self sharedPersistentStoreCooridinator] removePersistentStore:persistentStore
                                                              error:&err];
    SharedErrorBlock(err, METHOD_NAME);

    //remove all stores
    err = nil;
    [[NSFileManager defaultManager] removeItemAtURL:[self storeURL] error:&err];
    SharedErrorBlock(err, METHOD_NAME);
    err = nil;
    [[NSFileManager defaultManager] removeItemAtURL:[self storeURLSHM] error:&err];
    SharedErrorBlock(err, METHOD_NAME);
    err = nil;
    [[NSFileManager defaultManager] removeItemAtURL:[self storeURLWAL] error:&err];
    SharedErrorBlock(err, METHOD_NAME);
    
    NSDictionary *options = @{NSInferMappingModelAutomaticallyOption: @YES,NSMigratePersistentStoresAutomaticallyOption: @YES};
    
    [[self sharedPersistentStoreCooridinator] addPersistentStoreWithType:NSSQLiteStoreType
                                                           configuration:nil
                                                                     URL:[self storeURL]
                                                                 options:options
                                                                   error:&err];
    SharedErrorBlock(err, METHOD_NAME);
    
}

- (NSURL *)storeURL{
    NSURL *sURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                              inDomains:NSUserDomainMask] lastObject];
    sURL = [sURL URLByAppendingPathComponent:StoreURLString];
    return sURL;
}

- (NSURL *)storeURLSHM {
    NSURL *sURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                          inDomains:NSUserDomainMask] lastObject];
    sURL = [sURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@-shm", StoreURLString]];
    return sURL;
}

- (NSURL *)storeURLWAL {
    NSURL *sURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                          inDomains:NSUserDomainMask] lastObject];
    sURL = [sURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@-wal", StoreURLString]];
    return sURL;
}

@end
