//
//  MTSliderViewController.m
//  MusTale
//
//  Created by Zenan on 30/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTSliderViewController.h"
#import "MTInboxOutboxViewController.h"

@interface MTSliderViewController ()

@end

@implementation MTSliderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup initial main playlist
    self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Inbox"];
    UINavigationController *navigation = (UINavigationController*) self.topViewController;
    MTInboxOutboxViewController *inbox = (MTInboxOutboxViewController*) navigation.topViewController;
    [inbox loadInboxDedications];
    
    // Set up menu
    self.underRightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuView"];

    self.anchorLeftRevealAmount = 224.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changedTopViewControllerToGrid
{
    NSLog(@"change to grid");
    self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaylistGrid"];
}

-(void)changedTopViewControllerToList
{
    NSLog(@"change to list");
    self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaylistList"];
}

@end
