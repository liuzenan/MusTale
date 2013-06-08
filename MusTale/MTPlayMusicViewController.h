//
//  MTPlayMusicViewController.h
//  MusTale
//
//  Created by Zenan on 30/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTSongViewController.h"
#import "MarqueeLabel.h"

@interface MTPlayMusicViewController : UIViewController <SongPlayListDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *CDScroll;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuBtn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backBtn;
- (IBAction)showMenu:(id)sender;
- (IBAction)goBack:(id)sender;

@property (strong, nonatomic) NSArray *songList;
@property (strong, nonatomic) IBOutlet MarqueeLabel *songTitle;
@property (strong, nonatomic) IBOutlet MarqueeLabel *singerName;
- (IBAction)showTweets:(id)sender;
- (IBAction)showRecording:(id)sender;
- (IBAction)showTales:(id)sender;
- (IBAction)like:(id)sender;

@end
