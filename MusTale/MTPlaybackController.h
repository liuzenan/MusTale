//
//  MTPlaybackController.h
//  MusTale
//
//  Created by Zenan on 8/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MTSongModel.h"

@interface MTPlaybackController : NSObject

@property (strong, nonatomic) MPMoviePlayerController *player;
@property (strong, nonatomic) MTSongModel *currentSong;

+ (MTPlaybackController*) sharedInstance;
- (void) play;
- (void) stop;
- (void) pause;
- (BOOL) isPlaying;
- (void) togglePlayPause;
- (void) interrupted;
- (void)resetInterrupted;
- (BOOL)isInterrupted;

@end
