//
//  MTPlaybackController.m
//  MusTale
//
//  Created by Zenan on 8/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTPlaybackController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "MTNetworkController.h"

@implementation MTPlaybackController{
    BOOL interrupted;
}

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
    
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    
    [self.player prepareToPlay];
    
    [[MTNetworkController sharedInstance] listenTo:currentSong completeHandler:^(id data, NSError *error) {
        
        if (!error) {
            NSLog(@"listened to current sing:%@, data:%@", currentSong, data);
        } else {
            NSLog(@"error: %@", error);
        }
        
    }];
    

    UIImageView *art = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 400, 400)];
    NSURLRequest *request = [NSURLRequest requestWithURL:currentSong.artworkUrl100];
    
    [art setImageWithURLRequest:request
               placeholderImage:nil
                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                            MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
                            NSArray *keys = [NSArray arrayWithObjects:MPMediaItemPropertyAlbumTitle, MPMediaItemPropertyArtist, MPMediaItemPropertyArtwork, MPMediaItemPropertyTitle, nil];
                            NSArray *values = [NSArray arrayWithObjects:currentSong.collectionName, currentSong.artistName, artwork, currentSong.trackName, nil];
                            NSDictionary *mediaInfo = [NSDictionary dictionaryWithObjects:values forKeys:keys];
                            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:mediaInfo];
                            
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"set artwork failed: %@", error);
    }];
    
    

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

- (void)togglePlayPause
{
    if ([self isPlaying]) {
        [self play];
    } else {
        [self pause];
    }
}

- (void)interrupted
{
    interrupted = YES;
}

- (void)resetInterrupted
{
    interrupted = NO;
}

- (BOOL)isInterrupted
{
    return interrupted;
}

@end
