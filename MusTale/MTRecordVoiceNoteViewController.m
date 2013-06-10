//
//  MTRecordVoiceNoteViewController.m
//  MusTale
//
//  Created by Zenan on 30/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTRecordVoiceNoteViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UIColor+i7HexColor.h"
#import "UIViewController+SliderView.h"
#import "MTFloatMusicViewController.h"


@interface MTRecordVoiceNoteViewController (){
    BOOL isRecording;
    UIView *dark;
}

@end

@implementation MTRecordVoiceNoteViewController

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
    isRecording = NO;
    [[MTRecordingController sharedInstance] setDelegate:self];
    [self setStyling];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.songCover setImageWithURL:self.currentSong.artworkUrl100];
    [self.songTitle setText:self.currentSong.trackName];
    [self.singerName setText:self.currentSong.artistName];
    [[MTFloatMusicViewController sharedInstance] changeSong:self.currentSong];
    [[MTFloatMusicViewController sharedInstance] showFloatSong];
    
    [self setToInitialStyle];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [UIView animateWithDuration:0.2f animations:^{
        [self setToFinalStyle];
    }];
}

- (void)goBack{
    [UIView animateWithDuration:0.2f animations:^{
        [self setToInitialStyle];
    } completion:^(BOOL finished) {
        [self dismissModalViewControllerAnimated:NO];
    }];
}

- (void)confirm{
}

- (IBAction)toggleRecording:(id)sender {
    if (isRecording) {
        [self stopRecording];
    } else {
        [self startRecording];
    }
}

-(void)didFinishedRecording
{
    NSLog(@"finished recording");
    if (isRecording) {
        [self stopRecording];
    }
}


- (void)startRecording {
    isRecording = YES;
    UIImage *btnImg = [UIImage imageNamed:DEFAULT_STOP_BUTTON];
    [self.recordBtn setImage:btnImg forState:UIControlStateNormal];
    [[MTRecordingController sharedInstance] stopPlaying];
    [[MTRecordingController sharedInstance] startRecording];
}

- (void)stopRecording{
    isRecording = NO;
    UIImage *btnImg = [UIImage imageNamed:DEFAULT_RECORD_BUTTON];
    [self.recordBtn setImage:btnImg forState:UIControlStateNormal];
    [[MTRecordingController sharedInstance] stopRecording];
    [[MTRecordingController sharedInstance] startPlaying];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setSongTitle:nil];
    [self setSingerName:nil];
    [self setRecordBtn:nil];
    [self setSongCover:nil];
    [self setBackBtn:nil];
    [self setConfirmBtn:nil];
    [super viewDidUnload];
}

- (void)setToInitialStyle
{
    [self.songCover setTransform:CGAffineTransformMakeScale(0.8, 0.8)];
    [self.recordBtn setTransform:CGAffineTransformMakeScale(0.1, 0.1)];
    dark.alpha = 0.0f;
    self.recordBtn.alpha = 0.0f;
    [self.singerName setTransform:CGAffineTransformMakeTranslation(0, 0)];
    [[MTFloatMusicViewController sharedInstance].draggableView setAlpha:0.0f];
}

- (void)setToFinalStyle
{
    [self.songCover setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];
    [self.recordBtn setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];
    dark.alpha = 0.6f;
    self.recordBtn.alpha = 1.0f;
    [self.singerName setTransform:CGAffineTransformMakeTranslation(0, -30.0f)];
    [[MTFloatMusicViewController sharedInstance].draggableView setAlpha:1.0f];
}

- (void)setStyling
{
    CGPoint center = [self.songCover center];
    CGRect frame = self.songCover.frame;
    frame.size.width = frame.size.height = RECORD_SONG_VIEW_RADIUS * 2;
    self.songCover.frame = frame;
    [self.songCover setCenter:center];
    self.songCover.layer.cornerRadius = RECORD_SONG_VIEW_RADIUS;
    dark = [[UIView alloc] initWithFrame:self.songCover.frame];
    CGRect darkFrame = dark.frame;
    darkFrame.origin.x = darkFrame.origin.y = 0.0f;
    dark.frame = darkFrame;
    dark.layer.cornerRadius = RECORD_SONG_VIEW_RADIUS;
    [dark setAlpha:0.6];
    dark.backgroundColor = [UIColor blackColor];
    [self.songCover addSubview:dark];
    self.songCover.layer.masksToBounds = YES;
    self.songCover.contentMode = UIViewContentModeScaleAspectFill;
    
    [self setTextStyle];
    
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setImage:[UIImage imageNamed:DEFAULT_ICON_BACK] forState:UIControlStateNormal];
    [back sizeToFit];
    CGRect backFrame = back.frame;
    NSLog(@"menu frame: %@", NSStringFromCGRect(backFrame));
    backFrame.size.width += 20.0f;
    back.frame = backFrame;
    [back setShowsTouchWhenHighlighted:YES];
    [back addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirm setImage:[UIImage imageNamed:DEFAULT_ICON_CONFIRM] forState:UIControlStateNormal];
    [confirm sizeToFit];
    CGRect confirmFrame = confirm.frame;
    NSLog(@"menu frame: %@", NSStringFromCGRect(confirmFrame));
    confirmFrame.size.width += 20.0f;
    confirm.frame = confirmFrame;
    [confirm setShowsTouchWhenHighlighted:YES];
    [confirm addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    
    [self.backBtn setCustomView:back];
    [self.confirmBtn setCustomView:confirm];
    
    [self.confirmBtn setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.backBtn setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    self.view.backgroundColor = [UIColor colorWithHexString:MUSIC_BG_COLOR];
    
}

- (void) setTextStyle{
    self.songTitle.fadeLength = 10.0f;
    self.singerName.fadeLength = 10.0f;
    self.songTitle.continuousMarqueeExtraBuffer = 80.0f;
    self.singerName.continuousMarqueeExtraBuffer = 80.0f;
    [self.singerName setMarqueeType:MLContinuous];
    [self.songTitle setMarqueeType:MLContinuous];
    [self.singerName setAnimationDelay:3.0];
    [self.songTitle setAnimationDelay:3.0];
    [self.songTitle setFont:[UIFont fontWithName:LATO_BLACK size:22.0f]];
    [self.songTitle setTextColor:[UIColor whiteColor]];
    [self.songTitle setTextAlignment:UITextAlignmentCenter];
    [self.singerName setTextColor:[UIColor whiteColor]];
    [self.singerName setFont:[UIFont fontWithName:LATO_REGULAR size:14.0f]];
    [self.singerName setTextAlignment:UITextAlignmentCenter];
    [self.songTitle setBackgroundColor:[UIColor clearColor]];
    [self.singerName setBackgroundColor:[UIColor clearColor]];
}

- (IBAction)insertAtFront:(id)sender {
}

- (IBAction)insertAtBack:(id)sender {
}
@end
