//
//  MTSliderViewController.m
//  MusTale
//
//  Created by Zenan on 30/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTSliderViewController.h"

@interface MTSliderViewController ()

@end

@implementation MTSliderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup initial main playlist
    self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaylistList"];
    
    // Set up menu
    self.underRightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuView"];

    self.anchorLeftRevealAmount = 200.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
