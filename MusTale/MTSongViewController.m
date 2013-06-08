//
//  MTSongViewController.m
//  MusTale
//
//  Created by Zenan on 5/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTSongViewController.h"
#import "MTPlaybackController.h"

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
    }
    return self;
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification
{
    NSLog(@"music stopped");
    [self stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:[[MTPlaybackController sharedInstance] player]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self addGestureRecognizersToView:self.songview];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self stopRotate];
    [super viewWillDisappear:animated];
}

- (void)loadView {
    [super loadView];
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


// rotating
- (void) startRotate {
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:UPDATE_INTERVAL target:self selector:@selector(update) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void) stopRotate {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}


- (void) update{
    [self rotateView];
    [self changeProgress];
}


// set progress 
- (void)changeProgress
{
    MPMoviePlayerController *player = [[MTPlaybackController sharedInstance] player];
    NSTimeInterval current = player.currentPlaybackTime;
    CGFloat percent = (double) current / (double) player.duration;
    
    if (percent >= 0.0f && percent <= 1.0f) {
        self.songview.progress.percent = percent * 100;
        [self.songview.progress setNeedsDisplay];
    }
}


- (void) setProgressPercent:(CGFloat)p_percent{
    if (p_percent >= 0.0f && p_percent <= 100.0f) {
        self.songview.progress.percent = p_percent;
        [self.songview.progress setNeedsDisplay];
    }
}


- (void) rotateView {
    self.songview.transform = CGAffineTransformRotate(self.songview.transform, M_PI / 200.0f);
}


- (void) singleTap:(UIRotationGestureRecognizer *)gesture {
    if (self.timer) {
        [self pause];
    } else {
        [self play];
    }
}

- (void) pause {
    
    [self.songview removeStateImage];
    [self.songview addStateImage:kStateInit];
    [[MTPlaybackController sharedInstance] pause];
    [self stopRotate];
    [self.delegate didPausedPlaying:self];
}

- (void) stop {
    
    [self.songview removeStateImage];
    [self.songview addStateImage:kStateInit];
    [self setProgressPercent:0];
    [[MTPlaybackController sharedInstance] stop];
    [self stopRotate];
    self.songview.transform = CGAffineTransformMakeRotation(0.0);
    [self.delegate didFinishedPlaying:self];
}

- (void)play
{
    [[MTPlaybackController sharedInstance] setCurrentSong:self.songmodel];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:[[MTPlaybackController sharedInstance] player]];
    [self.songview removeStateImage];
    [self.songview addStateImage:kStatePause];
    [self startRotate];
    [[MTPlaybackController sharedInstance] play];
    [self.delegate didStartedPlaying:self];
}

- (void) reinit {
    [self stop];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
