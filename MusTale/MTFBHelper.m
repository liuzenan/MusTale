//
//  SGFBHelper.m
//  StreetGaGaApp
//
//  Created by Xujie Song on 29/05/13.
//  Copyright (c) 2013 StreetGaGa. All rights reserved.
//

#import "MTFBHelper.h"

@implementation MTFBHelper


NSString *const FBSessionStateChangedNotification = @"com.streetgaga.Login:FBSessionStateChangedNotification";

/*
 * Callback for session changes.
 */

+ (MTFBHelper*) sharedFBHelper {
    static MTFBHelper *sharedFBHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFBHelper = [[self alloc] init];
    });
    return sharedFBHelper;
}

- (NSString*)fbToken {
   return [[[FBSession activeSession] accessTokenData] accessToken];
}

- (id)init {
    if (self = [super init]) {
    }
    return self;
}


- (void)closeSession {
    [FBSession.activeSession close];
}

- (BOOL)isOpen {
    return [[FBSession activeSession] isOpen];
}

/*
 * Opens a Facebook session and optionally shows the login UX.
 */
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI
                  completionHandler:(FBOpenSessionHandler)handler {
    NSArray* permissions = [NSArray arrayWithObjects:@"email", nil];
    return [FBSession openActiveSessionWithReadPermissions:permissions
                                              allowLoginUI:allowLoginUI
                                         completionHandler:handler];
}

- (BOOL)handleOpenURL:(NSURL*)url {
    NSLog(@"FBHelper handleOpenURL");
    return [FBSession.activeSession handleOpenURL:url];
}
@end
