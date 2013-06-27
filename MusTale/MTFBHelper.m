//
//  MTFBHelper.h
//  MusTale
//
//  Created by Jiao Jing Ping on 15/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
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

- (void)closeSessionAndClearToken {
    [[FBSession activeSession] closeAndClearTokenInformation];
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
    NSArray* permissions = [NSArray arrayWithObjects:@"basic_info", @"email", nil];
    return [FBSession openActiveSessionWithReadPermissions:permissions
                                              allowLoginUI:allowLoginUI
                                         completionHandler:handler];
}

- (void) searchFriendMatchingTerm:(NSString*)term completeHandler:(NetworkCompleteHandler)handler{
    NSString *query =
    @"{"
    @"'friends':'SELECT uid2 FROM friend WHERE uid1 = me() LIMIT 25',"
    @"'friendinfo':'SELECT uid, name, pic_square FROM user WHERE name Like 'jim' AND uid IN (SELECT uid2 FROM #friends)',"
    @"}";
    //  query = [NSString stringWithFormat:query,term];
    NSLog(query,nil);
    // Set up the query parameter
    NSDictionary *queryParam = @{ @"q": query };
    // Make the API request that uses FQL
    
    if ([self isOpen]) {
        [FBRequestConnection startWithGraphPath:@"/fql"
                                     parameters:queryParam
                                     HTTPMethod:@"GET"
                              completionHandler:^(FBRequestConnection *connection,
                                                  id result,
                                                  NSError *error) {
                                  if (error) {
                                      NSLog(@"Error: %@", [error localizedDescription]);
                                      handler(nil,error);
                                  } else {
                                      NSLog(@"Result: %@", result);
                                      handler(result,nil);
                                  }
                              }];
    } else {
        [self openSessionWithAllowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
            [FBRequestConnection startWithGraphPath:@"/fql"
                                         parameters:queryParam
                                         HTTPMethod:@"GET"
                                  completionHandler:^(FBRequestConnection *connection,
                                                      id result,
                                                      NSError *error) {
                                      if (error) {
                                          NSLog(@"Error: %@", [error localizedDescription]);
                                          handler(nil,error);
                                      } else {
                                          NSLog(@"Result: %@", result);
                                          handler(result,nil);
                                      }
                                  }];
        }];
    }
}

- (BOOL)handleOpenURL:(NSURL*)url {
    NSLog(@"FBHelper handleOpenURL");
    return [FBSession.activeSession handleOpenURL:url];
}
@end
