//
//  MTPlayMusicViewController.h
//  MusTale
//
//  Created by Zenan on 30/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTSongViewController.h"

extern CGFloat const DEFAULT_SONG_VIEW_RADIUS;
extern CGFloat const DEFAULT_SONG_VIEW_SEPERATION;
extern CGFloat const DEFAULT_MINIMIZED_VIEW_HEIGHT;

@interface MTPlayMusicViewController : UIViewController <SongPlayListDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *CDScroll;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuBtn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backBtn;
- (IBAction)showMenu:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *goBack;

@property (strong, nonatomic) NSArray *songList;
@property (strong, nonatomic) IBOutlet UILabel *songTitle;
@property (strong, nonatomic) IBOutlet UILabel *singerName;

@end
