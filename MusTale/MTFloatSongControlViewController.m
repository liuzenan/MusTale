//
//  MTFloatSongControlViewController.m
//  MusTale
//
//  Created by Zenan on 16/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTFloatSongControlViewController.h"
#import "MTFloatSongControlView.h"
#import "MTPlaylistController.h"
#import "MTPlaybackController.h"

@interface MTFloatSongControlViewController ()

@end

@implementation MTFloatSongControlViewController

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
    [self setPlayButtonImage];
    [self setButtonState];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playPreviousSong:(id)sender {
    if ([[MTPlaylistController sharedInstance] hasPreviousSong]) {
        [[MTPlaybackController sharedInstance] interrupted];
        [[MTPlaylistController sharedInstance] playPreviousSong];
        [[MTPlaybackController sharedInstance] resetInterrupted];
    }
    [self setButtonState];
}

- (IBAction)togglePlay:(id)sender {
    [[MTPlaylistController sharedInstance] togglePlay];
    [self setPlayButtonImage];
}

- (void) setPlayButtonImage {
    MTFloatSongControlView *view = (MTFloatSongControlView*) self.view;
    if ([[MTPlaybackController sharedInstance] isPlaying]) {
        [view.pausePlayBtn setImage:[UIImage imageNamed:@"control-pause.png"] forState:UIControlStateNormal];
    } else {
        [view.pausePlayBtn setImage:[UIImage imageNamed:@"control-play.png"] forState:UIControlStateNormal];
    }
}

- (void) setButtonState {
    MTFloatSongControlView *view = (MTFloatSongControlView*) self.view;
    if ([[MTPlaylistController sharedInstance] hasNextSong]) {
        [view.nextSongBtn setEnabled:YES];
        [view.nextSongBtn setAlpha:0.7f];
    } else {
        [view.nextSongBtn setEnabled:NO];
        [view.nextSongBtn setAlpha:0.1f];
    }
    
    if ([[MTPlaylistController sharedInstance] hasPreviousSong]) {
        [view.previousSongBtn setEnabled:YES];
        [view.previousSongBtn setAlpha:0.7f];
    } else {
        [view.previousSongBtn setEnabled:NO];
        [view.previousSongBtn setAlpha:0.1f];
    }
}

- (IBAction)playNextSong:(id)sender {
    if ([[MTPlaylistController sharedInstance] hasNextSong]) {
        [[MTPlaybackController sharedInstance] interrupted];
        [[MTPlaylistController sharedInstance] playNextSong];
        [[MTPlaybackController sharedInstance] resetInterrupted];
    }
    [self setButtonState];
}

@end
