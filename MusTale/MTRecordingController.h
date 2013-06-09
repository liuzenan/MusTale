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

@interface MTRecordingController : NSObject <AVAudioRecorderDelegate>
{
	NSMutableDictionary *recordSetting;
	NSMutableDictionary *editedObject;
	NSString *recorderFilePath;
	AVAudioRecorder *recorder;
	AVAudioPlayer *audioPlayer;
}

+ (MTRecordingController*) sharedInstance;
-(void) startRecording;
-(void) stopRecording;
-(void) startPlaying;
-(void) stopPlaying;

@end
