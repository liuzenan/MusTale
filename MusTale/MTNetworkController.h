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
#import "MTDedicationModel.h"
@interface MTNetworkController : NSObject
@property (nonatomic,strong) MTUserModel* currentUser;
@property (nonatomic) BOOL isDebugMode;
+ (MTNetworkController*) sharedInstance;
- (BOOL) isLoggedIn;
- (void) fbLogin:(FBLoginCompleteHandler)completeHandler;
- (void) signUpViaFacebook:(NetworkCompleteHandler)handler;
- (void) logout:(NetworkCompleteHandler)completeHandler;


#pragma mark user
- (void) getUserInfoWithUserID:(NSString*)uid completehandler:(NetworkCompleteHandler)handler;
- (void) getUserInfoWithFacebookID:(NSString*)fbid completehandler:(NetworkCompleteHandler)handler;

#pragma mark songs
// Get song from itune based on itune_track_id, and register song to server
- (void) getSongInfoWithItuneTrackId:(NSString*)itune_track_id completeHandler:(NetworkCompleteHandler)handler;

// Register itune song to server
- (void) registerSongToServer:(MTSongModel*)song completeHandler:(NetworkCompleteHandler)handler;

// Add listen count of the song
- (void) listenTo:(MTSongModel*)song completeHandler:(NetworkCompleteHandler)handler;

// Get popular songs
- (void) getPopularSongs:(NSInteger)limit completeHandler:(NetworkCompleteHandler)handler;

#pragma mark tale
- (void) getTalesOfSong:(NSString*)songId completeHandler:(NetworkCompleteHandler)handler;

// .CAF voice file 
- (void) postVoiceTale:(NSData*)voiceData tale:(MTTaleModel*)tale to:(MTSongModel*)song completeHandler:(NetworkCompleteHandler)handler;

//- (void) uploadTale:(MTTaleModel*)tale completeHandler:(NetworkCompleteHandler)handler;

- (void) postTale:(MTTaleModel*)tale to:(MTSongModel*)song completeHandler:(NetworkCompleteHandler)handler;
- (void) postTaleWithSongId:(MTTaleModel*)tale to:(NSString*)songID completeHandler:(NetworkCompleteHandler)handler;

- (void) postCommentToTale:(MTCommentsModel*)comment completeHandler:(NetworkCompleteHandler)handler;
- (void) getCommentsOfTale:(NSString*)taleId completeHandler:(NetworkCompleteHandler)handler;

- (void) likeTale:(NSString*)taleID compeleteHandler:(NetworkCompleteHandler)handler;
- (void) unlikeTale:(NSString*)taleID compeleteHandler:(NetworkCompleteHandler)handler;

#pragma mark dedication

// Return dedication model
- (void) dedicateTaleToFacebookUsers:(MTTaleModel*)tale toFacebookUsers:(NSArray*)fbIds completeHandler:(NetworkCompleteHandler)handler;

- (void) readDedication:(MTDedicationModel*)dedication completeHandler:(NetworkCompleteHandler)handler;

- (void) getMyInboxWithCompleteHandler:(NetworkCompleteHandler)handler;
- (void) getMyOutboxWithCompleteHandler:(NetworkCompleteHandler)handler;
- (void) getDedicationsFromUser:(NSString*)from toUser:(NSString*)to completeHandler:(NetworkCompleteHandler)handler;


@end
