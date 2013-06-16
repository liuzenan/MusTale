//
//  MTPlaylistController.h
//  MusTale
//
//  Created by Zenan on 30/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTSongModel.h"

@interface MTPlaylistController : NSObject

@property (nonatomic, strong) NSArray *songs;
+ (MTPlaylistController*) sharedInstance;
- (BOOL) hasNextSong;
- (BOOL) hasPreviousSong;
- (void) playNextSong;
- (void) playPreviousSong;
- (void) playFirstSong;
- (void) addSongToList:(MTSongModel*)song;
- (void) removeSongFromList:(MTSongModel*)song;
- (void)playSongAtIndex:(NSInteger)index;
- (NSInteger)currentSongIndex;
- (MTSongModel*)currentSong;
- (void)togglePlay;
@end
