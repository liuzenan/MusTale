//
//  MTConstants.h
//  MusTale
//
//  Created by Zenan on 2/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const LATO_BLACK;
extern NSString *const LATO_BLACKITALIC;
extern NSString *const LATO_BOLD;
extern NSString *const LATO_BOLDITALIC;
extern NSString *const LATO_HAIRLINE;
extern NSString *const LATO_HAIRLINEITALIC;
extern NSString *const LATO_ITALIC;
extern NSString *const LATO_LIGHT;
extern NSString *const LATO_LIGHTITALIC;
extern NSString *const LATO_REGULAR;
extern NSString * const DEFAULT_PLAY_IMAGE;
extern NSString * const DEFAULT_PAUSE_IMAGE;
extern NSString * const DEFAULT_PLUS_IMAGE;
extern NSString * const FLAT_GREEN_COLOR;
extern NSString * const FLAT_YELLOW_COLOR;
extern NSString * const FLAT_BLUE_COLOR;
extern NSString * const FLAT_WHITE_COLOR;
extern NSString * const FLAT_RED_COLOR;
extern NSString * const FLAT_ORANGE_COLOR;
extern NSString * const FLAT_BLUE_HIGHLIGHT_COLOR;
extern NSString * const MUSIC_BG_COLOR;
extern CGFloat const DEFAULT_SONG_VIEW_RADIUS;
extern CGFloat const RECORD_SONG_VIEW_RADIUS;
extern CGFloat const DEFAULT_SONG_VIEW_SEPERATION;
extern CGFloat const DEFAULT_MINIMIZED_VIEW_HEIGHT;
extern NSString * const USER_RECORD_FILE_NAME;
extern NSString * const DEFAULT_STOP_BUTTON;
extern NSString * const DEFAULT_RECORD_BUTTON;
extern NSString * const DEFAULT_ICON_BACK;
extern NSString * const DEFAULT_ICON_CONFIRM;
extern NSString * const DEFAULT_CD_CENTER_IMAGE;

extern NSString *const ICON_TWEETS;
extern NSString *const ICON_RECORD;
extern NSString *const ICON_WRITE;
extern NSString *const ICON_TALE;
extern NSString *const ICON_LIKE;

extern NSString *const MTSongScrollNotification;

#define NAVBAR_HEIGHT 44.0f
#define NUM_OF_CONTROLS 5
#define CONTROL_BUTTON_RADIUS 20.0f
#define PROGRESS_VIEW_WIDTH 10.0f
#define kFLOAT_MUSIC_TAG 1345
#define OUTER_CIRCLE_WIDTH 40.0f
#define REMOVABLE_BUTTON_TAG 243
#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@interface MTConstants : NSObject

@end
