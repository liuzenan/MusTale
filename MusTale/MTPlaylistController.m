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

- (void)songDidStopPlaying:(NSNotification*)notification
{
    if ([self.songs count] > 0 && currentSongIndex < [self.songs count] - 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MTPlayNextSongNotification object:self];
    }
}

-(void)playNextSong
{
    currentSongIndex += 1;
    if ([self.songs count] > 0 && [self.songs count] > currentSongIndex) {
        [[MTPlaybackController sharedInstance] stop];
        [[MTPlaybackController sharedInstance] setCurrentSong:[self.songs objectAtIndex:currentSongIndex]];
        [[MTPlaybackController sharedInstance] play];
    }
}

-(void)playPreviousSong
{
    currentSongIndex -= 1;
    if ([self.songs count] > 0 && currentSongIndex > 0 && currentSongIndex < [self.songs count]) {
        [[MTPlaybackController sharedInstance] stop];
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

@end
