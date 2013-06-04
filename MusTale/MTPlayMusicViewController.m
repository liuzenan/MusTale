//
//  MTPlayMusicViewController.m
//  MusTale
//
//  Created by Zenan on 30/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTPlayMusicViewController.h"
#import "UIViewController+SliderView.h"
#import "MTNetworkController.h"

@interface MTPlayMusicViewController ()

@end

@implementation MTPlayMusicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.CDScroll.pagingEnabled = YES;
    self.CDScroll.showsHorizontalScrollIndicator = NO;
    
    [self loadSongs];
    
}

- (void) loadSongs
{
    [MTNetworkController testLoadSongWithResult];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setupTopViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCDScroll:nil];
    [super viewDidUnload];
}
@end
