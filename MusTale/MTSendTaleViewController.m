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
    [self setStyling];
    
}

- (void)dismiss
{

    [UIView animateWithDuration:0.6f animations:^{
        [self setInitialStyle];
    } completion:^(BOOL finished) {
        [self dismissModalViewControllerAnimated:NO];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.bgImgView = [[RCBlurredImageView alloc] initWithImage:self.bgImg];
    [self.view insertSubview:self.bgImgView belowSubview:self.overlayView];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tapGes.numberOfTapsRequired = 1;
    tapGes.delegate = self;
    [self.view addGestureRecognizer:tapGes];
    [self setInitialStyle];
    [super viewWillAppear:animated];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.6f animations:^{
        [self setFinalStyle];
    }];
}

-(void)setFinalStyle
{
    CGRect frame = self.overlayView.frame;
    frame.origin.y = self.view.frame.size.height - frame.size.height;
    self.overlayView.frame = frame;
    [self.bgImgView setBlurIntensity:1.0f];
}

-(void)setInitialStyle
{
    CGRect frame = self.overlayView.frame;
    frame.origin.y = self.view.frame.size.height;
    self.overlayView.frame = frame;
    [self.bgImgView setBlurIntensity:0.0f];
}

-(void) setStyling
{
    [self.overlayView setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.7]];
}

- (void)viewDidUnload {
    [self setOverlayView:nil];
    [super viewDidUnload];
}
- (IBAction)sendTale:(id)sender {
    [self.delegate sendCurrentTale];
}

- (IBAction)cancel:(id)sender {
    [self dismiss];
}
@end
