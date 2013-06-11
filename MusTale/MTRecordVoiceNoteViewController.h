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
#import "MTRecordingController.h"

@interface MTRecordVoiceNoteViewController : UIViewController <MTRecorderDelegate>

@property (nonatomic, strong) MTSongModel *currentSong;
@property (strong, nonatomic) IBOutlet MarqueeLabel *songTitle;
@property (strong, nonatomic) IBOutlet MarqueeLabel *singerName;
@property (strong, nonatomic) IBOutlet UIButton *recordBtn;
@property (strong, nonatomic) IBOutlet UIImageView *songCover;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backBtn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *confirmBtn;
- (IBAction)toggleRecording:(id)sender;

- (void)setCurrentSong:(MTSongModel*)song;
@end
