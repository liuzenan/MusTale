//
//  SGFBHelper.h
//  StreetGaGaApp
//
//  Created by Xujie Song on 29/05/13.
//  Copyright (c) 2013 StreetGaGa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

typedef void (^FBOpenSessionHandler)(FBSession *session,FBSessionState state,NSError *error);
extern NSString *const FBSessionStateChangedNotification;

@interface MTFBHelper : NSObject
@property (strong,nonatomic) NSString* fbToken;
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI
                  completionHandler:(FBOpenSessionHandler)handler;

- (BOOL)handleOpenURL:(NSURL*)url;
- (void)closeSession;
- (BOOL)isOpen;

+ (MTFBHelper*) sharedFBHelper;
@end
