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

@interface MTRecordVoiceNoteViewController ()

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

    [self setStyling];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.songCover setImageWithURL:self.currentSong.artworkUrl100];
    [self.songTitle setText:self.currentSong.trackName];
    [self.singerName setText:self.currentSong.artistName];
}

- (IBAction)goBack:(id)sender {
}

- (IBAction)send:(id)sender {
    
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
    [self setMenuBtn:nil];
    [super viewDidUnload];
}

- (void)setStyling
{
    CGPoint center = [self.songCover center];
    CGRect frame = self.songCover.frame;
    frame.size.width = frame.size.height = DEFAULT_SONG_VIEW_RADIUS * 2;
    self.songCover.frame = frame;
    [self.songCover setCenter:center];
    self.songCover.layer.cornerRadius = DEFAULT_SONG_VIEW_RADIUS;
    UIView *dark = [[UIView alloc] initWithFrame:self.songCover.frame];
    CGRect darkFrame = dark.frame;
    darkFrame.origin.x = darkFrame.origin.y = 0.0f;
    dark.frame = darkFrame;
    dark.layer.cornerRadius = DEFAULT_SONG_VIEW_RADIUS;
    [dark setAlpha:0.6];
    dark.backgroundColor = [UIColor blackColor];
    [self.songCover addSubview:dark];
    self.songCover.layer.masksToBounds = YES;
    self.songCover.contentMode = UIViewContentModeScaleAspectFill;
    
    [self setTextStyle];
    
    [self.menuBtn setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
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
