//
//  MTPlaylistController.m
//  MusTale
//
//  Created by Zenan on 30/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTPlaylistController.h"
#import "MTPlaybackController.h"

@implementation MTPlaylistController{
    NSInteger currentSongIndex;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.songs = [NSMutableArray array];
        currentSongIndex = -1;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(songDidStopPlaying:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:[[MTPlaybackController sharedInstance] player]];
    }
    return self;
}


+ (MTPlaylistController*) sharedInstance
{
    static MTPlaylistController *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[MTPlaylistController alloc] init];
    });
    
    return __sharedInstance;
}

- (NSInteger)currentSongIndex
{
    return currentSongIndex;
}

- (MTSongModel*)currentSong
{
    return [self.songs objectAtIndex:currentSongIndex];
}

- (void)playSongAtIndex:(NSInteger)index
{
    if ([self.songs count] > 0 && index >=0 && index < [self.songs count]) {
        currentSongIndex = index;
        [[MTPlaybackController sharedInstance] stop];
        [[MTPlaybackController sharedInstance] setCurrentSong:[self.songs objectAtIndex:currentSongIndex]];
        [[MTPlaybackController sharedInstance] play];
    }
}

-(void)playFirstSong
{
    if ([self.songs count] > 0) {
        currentSongIndex = 0;
        [[MTPlaybackController sharedInstance] stop];
        [[MTPlaybackController sharedInstance] setCurrentSong:[self.songs objectAtIndex:currentSongIndex]];
        [[MTPlaybackController sharedInstance] play];
    }
}

-(void)playNextSong
{
    currentSongIndex += 1;
    NSLog(@"play next song: %d", currentSongIndex);
    if ([self.songs count] > 0 && [self.songs count] > currentSongIndex) {
        
        [[MTPlaybackController sharedInstance] setCurrentSong:[self.songs objectAtIndex:currentSongIndex]];
        [[MTPlaybackController sharedInstance] play];
    }
}

- (void)togglePlay
{
    if ([[MTPlaybackController sharedInstance] currentSong]) {
        if ([[MTPlaybackController sharedInstance] isPlaying]) {
            [[MTPlaybackController sharedInstance] pause];
        } else {
            [[MTPlaybackController sharedInstance] play];
        }
    }
}

- (BOOL) hasNextSong
{
    if ([self.songs count] > 0 && currentSongIndex >= 0 && currentSongIndex < [self.songs count] - 1) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL) hasPreviousSong
{
    if ([self.songs count] > 0 && currentSongIndex > 0 && currentSongIndex < [self.songs count]) {
        return YES;
    } else {
        return NO;
    }
}

-(void)playPreviousSong
{
    currentSongIndex -= 1;
    NSLog(@"play previous song: %d", currentSongIndex);
    if ([self.songs count] > 0 && currentSongIndex >= 0 && currentSongIndex < [self.songs count]) {
        
        [[MTPlaybackController sharedInstance] setCurrentSong:[self.songs objectAtIndex:currentSongIndex]];
        [[MTPlaybackController sharedInstance] play];
    }
}


-(void)addSongToList:(MTSongModel *)song
{
    
}

-(void)removeSongFromList:(MTSongModel *)song
{
    
}

- (void)songDidStopPlaying:(NSNotification*)notification
{
    NSLog(@"song did stop playing");
    if (![[MTPlaybackController sharedInstance] isInterrupted]) {
        if ([self.songs count] > 0 && currentSongIndex < [self.songs count] - 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:MTPlayNextSongNotification object:self];
        }
    }
}


@end
