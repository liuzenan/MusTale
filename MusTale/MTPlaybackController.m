//
//  MTPlaybackController.m
//  MusTale
//
//  Created by Zenan on 8/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTPlaybackController.h"

@implementation MTPlaybackController

- (id)init
{
    self = [super init];
    if (self) {
        self.player = [[MPMoviePlayerController alloc] init];
    }
    return self;
}

+ (MTPlaybackController*) sharedInstance
{
    static MTPlaybackController *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[MTPlaybackController alloc] init];
    });
    
    return __sharedInstance;
}

- (void) setCurrentSong:(MTSongModel *)currentSong
{
    _currentSong = currentSong;
    if (!self.player) {
        self.player = [[MPMoviePlayerController alloc] initWithContentURL:currentSong.previewUrl];
    } else {
        [self.player stop];
        self.player.contentURL = currentSong.previewUrl;
    }
    
    [self.player prepareToPlay];
}

- (void) play
{
    [self.player play];
}

- (void) stop
{
    [self.player stop];
}

- (void) pause
{
    [self.player pause];
}

- (BOOL) isPlaying
{
    if (self.player.playbackState == MPMoviePlaybackStatePlaying) {
        return YES;
    } else {
        return NO;
    }
}

@end
