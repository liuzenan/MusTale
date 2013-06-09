//
//  MTRecordVoiceNoteViewController.h
//  MusTale
//
//  Created by Zenan on 30/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTSongModel.h"
#import "MarqueeLabel.h"

@interface MTRecordVoiceNoteViewController : UIViewController

@property (nonatomic, strong) MTSongModel *currentSong;
@property (strong, nonatomic) IBOutlet MarqueeLabel *songTitle;
@property (strong, nonatomic) IBOutlet MarqueeLabel *singerName;
@property (strong, nonatomic) IBOutlet UIButton *recordBtn;
@property (strong, nonatomic) IBOutlet UIImageView *songCover;
- (IBAction)insertAtFront:(id)sender;
- (IBAction)insertAtBack:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backBtn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuBtn;
- (IBAction)goBack:(id)sender;
- (IBAction)showMenu:(id)sender;
- (IBAction)startRecording:(id)sender;
- (IBAction)stopRecording:(id)sender;


- (void)setCurrentSong:(MTSongModel*)song;
@end
