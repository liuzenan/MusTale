//
//  MTFBHelper.h
//  MusTale
//
//  Created by Jiao Jing Ping on 15/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
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
- (void)closeSessionAndClearToken;
- (void)searchFriendMatchingTerm:(NSString*)term completeHandler:(NetworkCompleteHandler)handler;
+ (MTFBHelper*) sharedFBHelper;
@end
