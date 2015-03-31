//
//  WUUContactPickerViewController.m
//  WakeUsUp
//
//  Created by David Cao on 9/13/14.
//  Copyright (c) 2014 David.Cao. All rights reserved.
//

#import "WUUContactPickerViewController.h"
#import "WUUNewAlarmViewController.h"
#import <AddressBookUI/AddressBookUI.h>

NSString *ContactPickerCellIdentifier = @"ContactPickerCellIdentifier";

@interface WUUContactPickerViewController ()

@property (strong, nonatomic) NSMutableDictionary *contactsDictionary;
@property (strong, nonatomic) NSMutableArray *sectionTitles;

- (void)close;
- (void)done;

@end

@implementation WUUContactPickerViewController

- (id)initWithNewAlarmController:(WUUNewAlarmViewController *)controller {
    
    if (self = [super init]) {
        
        [self setCreateAlarmController:controller];
        
        UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ios7-close-outline-white"] style:UIBarButtonItemStyleDone target:self action:@selector(close)];
        [[self navigationItem] setLeftBarButtonItem:close];
        
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
        [[self navigationItem] setRightBarButtonItem:done];
        
        [[self navigationItem] setTitle:@"Add Friends"];
        
        [self setSelected:[NSMutableArray array]];
        [self setSectionTitles:[NSMutableArray array]];
        [self setContactsDictionary:[NSMutableDictionary
                                     dictionaryWithDictionary:@{@"A": @[],
                                                                @"B": @[],
                                                                @"C": @[],
                                                                @"D": @[],
                                                                @"E": @[],
                                                                @"F": @[],
                                                                @"G": @[],
                                                                @"H": @[],
                                                                @"I": @[],
                                                                @"J": @[],
                                                                @"K": @[],
                                                                @"L": @[],
                                                                @"M": @[],
                                                                @"N": @[],
                                                                @"O": @[],
                                                                @"P": @[],
                                                                @"Q": @[],
                                                                @"R": @[],
                                                                @"S": @[],
                                                                @"T": @[],
                                                                @"U": @[],
                                                                @"V": @[],
                                                                @"W": @[],
                                                                @"X": @[],
                                                                @"Y": @[],
                                                                @"Z": @[]
                                                                }]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CFErrorRef err;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &err);
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFMutableArrayRef peopleMutable = CFArrayCreateMutableCopy(
                                                               kCFAllocatorDefault,
                                                               CFArrayGetCount(people),
                                                               people);
    CFArraySortValues(
                      peopleMutable,
                      CFRangeMake(0, CFArrayGetCount(peopleMutable)),
                      (CFComparatorFunction) ABPersonComparePeopleByName,
                      (void*)ABPersonGetSortOrdering());
    
    for (CFIndex i = 0; i < CFArrayGetCount(peopleMutable); i++)
    {
        ABRecordRef record = CFArrayGetValueAtIndex(peopleMutable, i);
        NSString *firstName = CFBridgingRelease(ABRecordCopyValue(record, kABPersonFirstNameProperty));
        NSString *lastName = CFBridgingRelease(ABRecordCopyValue(record, kABPersonLastNameProperty));
        NSString *phoneNumber;
        ABMultiValueRef phoneNumberMultiValue = ABRecordCopyValue(record, kABPersonPhoneProperty);
        NSUInteger phoneNumberIndex;
        for (phoneNumberIndex = 0; phoneNumberIndex < ABMultiValueGetCount(phoneNumberMultiValue); phoneNumberIndex++) {
            
            CFStringRef labelStingRef = ABMultiValueCopyLabelAtIndex (phoneNumberMultiValue, phoneNumberIndex);
            phoneNumber  = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneNumberMultiValue, phoneNumberIndex);
            phoneNumber = [[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];

            CFRelease(labelStingRef);
        }
        
        if (!firstName) {
            firstName = @"";
        }
        
        if (!lastName) {
            lastName = @"";
        }
        
        //only add if number exists and first and last aren't blank
        if (phoneNumber && ([phoneNumber length] != 0) && !(firstName.length == 0 && lastName.length == 0)) {
            
            //if it begins with a 1 we strip it (no area codes start with 1).
            if ([phoneNumber characterAtIndex:0] == '1') {
                phoneNumber = [phoneNumber substringFromIndex:1];
            }
            
            NSDictionary *dict = @{@"first": firstName,
                                   @"last": lastName,
                                   @"number": phoneNumber};
            if (lastName.length > 0) {
                NSString *letter = [[NSString stringWithFormat:@"%C", [lastName characterAtIndex:0]] uppercaseString];
                NSLog(@"Letter: %@", letter);
                
                NSMutableArray *array = [NSMutableArray arrayWithArray:[[self contactsDictionary] objectForKey:letter]];
                [array addObject:dict];
                [[self contactsDictionary] setObject:array forKey:letter];
                
                if (![[self sectionTitles] containsObject:letter]) {
                    [[self sectionTitles] addObject:letter];
                }
                
            } else if (firstName.length > 0) {
                NSString *letter = [[NSString stringWithFormat:@"%C", [firstName characterAtIndex:0]] uppercaseString];
                NSLog(@"Letter: %@", letter);
                
                NSMutableArray *array = [NSMutableArray arrayWithArray:[[self contactsDictionary] objectForKey:letter]];
                [array addObject:dict];
                [[self contactsDictionary] setObject:array forKey:letter];
                
                if (![[self sectionTitles] containsObject:letter]) {
                    [[self sectionTitles] addObject:letter];
                }
                
            }
        }
    }
    
    NSLog(@"letters: %@", [self sectionTitles]);
    NSLog(@"Contacts dictionary: %@", [self contactsDictionary]);
    
    CFRelease(peopleMutable);
    CFRelease(addressBook);
    CFRelease(people);
    
    [[self tableView] reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self sectionTitles] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *letter = [[self sectionTitles] objectAtIndex:section];
    return [[[self contactsDictionary] objectForKey:letter] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self sectionTitles] objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ContactPickerCellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ContactPickerCellIdentifier];
    }
    
    // Configure the cell...
    
    [cell setTintColor:[UIColor colorWithRed:26.0/255.0 green:161.0/255.0 blue:1 alpha:1.0]];
    
    NSString *sectionTitle = [[self sectionTitles] objectAtIndex:indexPath.section];
    NSArray *contacts = [[self contactsDictionary] objectForKey:sectionTitle];
    NSDictionary *contact = [contacts objectAtIndex:[indexPath row]];
    
    [[cell textLabel] setText:[NSString stringWithFormat:@"%@ %@", [contact objectForKey:@"first"], [contact objectForKey:@"last"]]];
    [[cell detailTextLabel] setText:[contact objectForKey:@"number"]];
    
    if ([[self selected] containsObject:indexPath]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if ([[self selected] containsObject:indexPath]) {
        [[self selected] removeObject:indexPath];
    } else {
        [[self selected] addObject:indexPath];
    }
    [tableView reloadData];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self sectionTitles];
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)done {
    
    NSMutableArray *contacts = [NSMutableArray array];
    
    for (NSIndexPath *indexPath in [self selected]) {
        NSString *sectionTitle = [[self sectionTitles] objectAtIndex:indexPath.section];
        NSArray *contactList = [[self contactsDictionary] objectForKey:sectionTitle];
        NSDictionary *contact = [contactList objectAtIndex:[indexPath row]];
        [contacts addObject:contact];
    }
    
    NSLog(@"Selected contacts: %@", contacts);
    
    [[self createAlarmController] setFriendIndexes:[self selected]];
    [[self createAlarmController] setFriends:contacts];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
