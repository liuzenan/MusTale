//
//  MTSendTaleViewController.m
//  MusTale
//
//  Created by Zenan on 30/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTSendTaleViewController.h"

@interface MTSendTaleViewController ()

@end

@implementation MTSendTaleViewController

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
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.bgImg) {
        self.bgImgView = [[RCBlurredImageView alloc] initWithImage:self.bgImg];
        [self.view insertSubview:self.bgImgView belowSubview:self.overlayView];
    } else {
        NSLog(@"bg img is nil!");
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.bgImgView setBlurIntensity:0.6f];
}

- (void)viewDidUnload {
    [self setOverlayView:nil];
    [super viewDidUnload];
}
@end
