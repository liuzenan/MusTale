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
#import "MTCommentsModel.h"
@interface MTNetworkController : NSObject
@property (nonatomic,strong) MTUserModel* currentUser;
@property (nonatomic) BOOL isDebugMode;
+ (MTNetworkController*) sharedInstance;
- (BOOL) isLoggedIn;
- (void) fbLogin:(FBLoginCompleteHandler)completeHandler;
- (void) signUpViaFacebook:(NetworkCompleteHandler)handler;
- (void) logout:(NetworkCompleteHandler)completeHandler;


#pragma mark user
- (void) getUserInfo:(MTUserModel*)user completehandler:(NetworkCompleteHandler)handler;

#pragma mark songs
- (void) postListenTo:(MTSongModel*)song completeHandler:(NetworkCompleteHandler)handler;
- (void) getPopularSongs:(NSInteger)limit completeHandler:(NetworkCompleteHandler)handler;

#pragma mark tale
- (void) postTale:(MTTaleModel*)tale to:(MTSongModel*)song completeHandler:(NetworkCompleteHandler)handler;
- (void) postCommentToTale:(MTCommentsModel*)comment completeHandler:(NetworkCompleteHandler)handler;
- (void) likeTale:(NSString*)taleID compeleteHandler:(NetworkCompleteHandler)handler;
- (void) unlikeTale:(NSString*)taleID compeleteHandler:(NetworkCompleteHandler)handler;
@end
