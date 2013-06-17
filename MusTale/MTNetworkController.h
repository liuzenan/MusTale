    //
//  MTNetworkController.h
//  MusTale
//
//  Created by Zenan on 30/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTUserModel.h"
#import "MTArtistModel.h"
#import "MTTaleModel.h"
#import "MTFBHelper.h"
#import "MTSongModel.h"
#import "MTListenModel.h"
@interface MTNetworkController : NSObject
@property (nonatomic,strong) MTUserModel* currentUser;
@property (nonatomic) BOOL isDebugMode;
+ (MTNetworkController*) sharedInstance;
- (BOOL) isLoggedIn;
- (void) fbLogin:(FBLoginCompleteHandler)completeHandler;
- (void) signUpViaFacebook:(NetworkCompleteHandler)handler;
- (void) logout:(NetworkCompleteHandler)completeHandler;

- (void) postListenTo:(MTSongModel*)song completeHandler:(NetworkCompleteHandler)handler;
- (void) getPopularSongs:(NSInteger)limit completeHandler:(NetworkCompleteHandler)handler;
@end
