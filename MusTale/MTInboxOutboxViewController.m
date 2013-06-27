//
//  MTInboxOutboxViewController.m
//  MusTale
//
//  Created by Zenan on 23/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTInboxOutboxViewController.h"
#import "UIViewController+SliderView.h"
#import "UIViewController+DoubleRightBarItems.h"
#import <QuartzCore/QuartzCore.h>
#import "MTSliderViewController.h"
#import "MTNetworkController.h"
#import "MTInboxCell.h"
#import "MTDedicationModel.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "NSDate+TimeAgo.h"
#import "UIColor+i7HexColor.h"

@interface MTInboxOutboxViewController (){
    InboxOutboxType boxType;
}

@end

@implementation MTInboxOutboxViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupRightMenuButton];
    [self setStyling];
    
    self.dedications = [NSMutableArray array];

}


- (void)setStyling{
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#fefef8"];
    self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 10.0f, 0.0f);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    MTSliderViewController *sliderController = (MTSliderViewController*)self.slidingViewController;
    self.delegate = sliderController;
    self.tableView.contentOffset = CGPointMake(0.0f, 44.0f);
    [self setupTopViewController];
    
    [self loadItems];
    
}

- (void)setType:(InboxOutboxType)type
{
    boxType = type;
}

- (void)showMenu
{
    [self.slidingViewController anchorTopViewTo:ECLeft];
}


- (void) loadItems
{
    if (boxType == kInbox) {
        [self loadInboxDedications];
    } else {
        [self loadOutboxDedications];
    }
}

- (void) loadInboxDedications
{
    [self setTitle:@"Inbox"];
    MTUserModel *currentUser = [[MTNetworkController sharedInstance] currentUser];
    NSLog(@"current user:%@", currentUser.ID);
    if (currentUser && currentUser.ID) {
        [[MTNetworkController sharedInstance] getDedicationsFromUser:nil
                                                              toUser:currentUser.ID
                                                     completeHandler:^(id data, NSError *error) {
                                                         
                                                         if (!error) {
                                                             self.dedications = [NSMutableArray arrayWithArray:data];
                                                             [self.tableView reloadData];
                                                         } else {
                                                             NSLog(@"%@", error);
                                                         }
                                                         
                                                     }];
    } else {
        NSLog(@"no current user");
    }

}

- (void) loadOutboxDedications
{
    [self setTitle:@"Outbox"];
    MTUserModel *currentUser = [[MTNetworkController sharedInstance] currentUser];
    if (currentUser && currentUser.ID) {
    NSLog(@"current user:%@", currentUser.ID);
    [[MTNetworkController sharedInstance] getDedicationsFromUser:currentUser.ID
                                                          toUser:nil
                                                 completeHandler:^(id data, NSError *error) {
                                                              
                                                              
                                                              if (!error) {
                                                                  self.dedications = [NSMutableArray arrayWithArray:data];
                                                                  [self.tableView reloadData];
                                                              } else {
                                                                  NSLog(@"%@", error);
                                                              }
                                                              
                                                          }];
    } else {
        NSLog(@"no current user");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dedications count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"inboxCell";
    MTInboxCell *cell = (MTInboxCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    MTDedicationModel *dedication = [self.dedications objectAtIndex:indexPath.row];

    MTUserModel *user;
    if (boxType == kInbox) {
        user = dedication.from;
    } else {
        user = dedication.to;
    }
    
    [cell.profilePic setImageWithURL:[NSURL URLWithString:user.profileURL]];
    [cell.userName setText:user.name];
    [cell.shortDedication setText:dedication.tale.text];
    [cell.date setText:[dedication.createdAt timeAgo]];
    
    [cell setStyling];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
