//
//  MTFloatMusicViewController.h
//  MusTale
//
//  Created by Zenan on 9/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHDraggingCoordinator.h"
#import "MTSongModel.h"


@interface MTFloatMusicViewController : UIViewController

@property (strong, nonatomic) CHDraggingCoordinator *draggingCoordinator;
@property (strong, nonatomic) CHDraggableView *draggableView;

+ (MTFloatMusicViewController*) sharedInstance;
- (void) changeSong:(MTSongModel *)song;
- (void) showFloatSong;
- (void) removeFloatSong;

@end
