//
//  MTSongViewController.h
//  MusTale
//
//  Created by Zenan on 5/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTSongModel.h"
#import "MTSongView.h"
#import "MTConstants.h"
#import <MediaPlayer/MediaPlayer.h>

extern CGFloat const UPDATE_INTERVAL;

@protocol SongPlayListDelegate <NSObject>
- (void) didStartedPlaying:(id)sender;
- (void) didPausedPlaying:(id)sender;
- (void) didFinishedPlaying:(id)sender;
@end

@interface MTSongViewController : UIViewController <UIGestureRecognizerDelegate>
@property (nonatomic,weak) id<SongPlayListDelegate> delegate;
@property (nonatomic,weak) MTSongView* songview;
@property (nonatomic,strong) MTSongModel* songmodel;
@property (strong, nonatomic) MPMoviePlayerController *player;

+ (MTSongViewController*) songViewControllerWithViewAndModel:(MTSongView*)songview Model:(MTSongModel*)songmodel;

- (void) reinit;


@end
