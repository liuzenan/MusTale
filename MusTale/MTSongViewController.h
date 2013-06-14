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
#import <SKBounceAnimation/SKBounceAnimation.h>



extern CGFloat const UPDATE_INTERVAL;

@protocol SongPlayListDelegate <NSObject>
- (void) didStartedPlaying:(id)sender;
- (void) didContinuePlaying:(id)sender;
- (void) didPausedPlaying:(id)sender;
- (void) didFinishedPlaying:(id)sender;
- (void) showTweets:(MTSongModel*)song;
- (void) recordVoice:(MTSongModel*)song;
- (void) writeMessage:(MTSongModel *)song;
- (void) showTales:(MTSongModel*)song;
- (void) likeSong:(MTSongModel*)song;

@end

typedef enum {kButtonTweets, kButtonRecord, kButtonWrite, kButtonTale, kButtonLike, kButtonPlay, kButtonToggle} ControlButtonType;

@interface MTSongViewController : UIViewController <UIGestureRecognizerDelegate, UIApplicationDelegate> {
    BOOL isCircleControlOn;
}

@property (nonatomic,weak) id<SongPlayListDelegate> delegate;
@property (nonatomic,weak) MTSongView* songview;
@property (nonatomic,strong) MTSongModel* songmodel;
@property (nonatomic,strong) NSMutableArray *controlButtons;
@property (nonatomic,assign) NSInteger index;

+ (MTSongViewController*) songViewControllerWithViewAndModel:(MTSongView*)songview Model:(MTSongModel*)songmodel;

- (void) play;
- (void) continuePlay;
- (void) startRotate;

@end
