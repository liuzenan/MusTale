//
//  MTRecordingController.h
//  MusTale
//
//  Created by Zenan on 30/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@protocol MTRecorderDelegate

- (void) didFinishedRecording;

@end

@interface MTRecordingController : NSObject <AVAudioRecorderDelegate>
{
	NSMutableDictionary *recordSetting;
	NSMutableDictionary *editedObject;
	NSString *recorderFilePath;
	AVAudioRecorder *recorder;
	AVAudioPlayer *audioPlayer;
}

@property (nonatomic, weak) id<MTRecorderDelegate> delegate;
+ (MTRecordingController*) sharedInstance;
-(void) startRecording;
-(void) stopRecording;
-(void) startPlaying;
-(void) stopPlaying;

@end
