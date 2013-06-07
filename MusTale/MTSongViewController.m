//
//  MTSongViewController.m
//  MusTale
//
//  Created by Zenan on 5/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTSongViewController.h"

@interface MTSongViewController ()

@property (nonatomic,strong) UIPanGestureRecognizer * panGesture;
@property (nonatomic,strong) UITapGestureRecognizer * tapGesture;
@property (nonatomic,strong) NSTimer * timer;
@end

CGFloat const UPDATE_INTERVAL = 0.01;

@implementation MTSongViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithViewAndModel:(MTSongView*) v Model:(MTSongModel*)m {
    if (self = [super init]) {
        self.songview = v;
        self.songmodel = m;
        self.player = [[MPMoviePlayerController alloc] initWithContentURL:self.songmodel.previewUrl];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self addGestureRecognizersToView:self.songview];
}

- (void)loadView {
    self.view = self.songview;
}

+ (MTSongViewController*) songViewControllerWithViewAndModel:(MTSongView*)songview Model:(MTSongModel*)songmodel {
    return [[MTSongViewController alloc] initWithViewAndModel:songview Model:songmodel];
}

- (void)addGestureRecognizersToView:(UIView *)the_view {
    
    the_view.userInteractionEnabled = YES;
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self.tapGesture setDelegate:self];
    [self.tapGesture setNumberOfTapsRequired:1]; // double tap
    [the_view addGestureRecognizer:self.tapGesture];
    
}

- (void) startRotate {
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:UPDATE_INTERVAL target:self selector:@selector(update) userInfo:nil repeats:YES];
    }
}

- (void) update{
    
}

- (void) stopRotate {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}


- (void) singleTap:(UIRotationGestureRecognizer *)gesture {
    if (self.timer) {
        [self pause];
        
    } else {
        [self play];
    }
}

- (void) pause {
    [self.songview addStateImage:kStatePause];
    [self.player stop];
    [self stopRotate];
}

- (void)play
{
    [self.songview removeStateImage];
    [self startRotate];
    [self.player play];
}

- (void) reinit {
    [self.songview addStateImage:kStateInit];
    self.songview.transform = CGAffineTransformMakeRotation(0.0);
    [self.player stop];
    [self stopRotate];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
