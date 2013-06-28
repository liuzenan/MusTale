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
- (void) getUserInfo:(MTUserModel*)user completehandler:(NetworkCompleteHandler)handler;

#pragma mark songs
- (void) postSong:(MTSongModel*)song completeHandler:(NetworkCompleteHandler)handler;
- (void) postListenTo:(MTSongModel*)song completeHandler:(NetworkCompleteHandler)handler;
- (void) getPopularSongs:(NSInteger)limit completeHandler:(NetworkCompleteHandler)handler;

#pragma mark tale
- (void) getTalesOfSong:(NSString*)songId completeHandler:(NetworkCompleteHandler)handler;

// .CAF voice file 
- (void) postVoiceTale:(NSData*)voiceData tale:(MTTaleModel*)tale to:(MTSongModel*)song completeHandler:(NetworkCompleteHandler)handler;
- (void) postTale:(MTTaleModel*)tale to:(MTSongModel*)song completeHandler:(NetworkCompleteHandler)handler;

- (void) postCommentToTale:(MTCommentsModel*)comment completeHandler:(NetworkCompleteHandler)handler;
- (void) getCommentsOfTale:(NSString*)taleId completeHandler:(NetworkCompleteHandler)handler;

- (void) likeTale:(NSString*)taleID compeleteHandler:(NetworkCompleteHandler)handler;
- (void) unlikeTale:(NSString*)taleID compeleteHandler:(NetworkCompleteHandler)handler;

#pragma mark dedication
//- (void) postTaleAndDedicationToFBUsers:(MTTaleModel*)tale toSong:(MTSongModel*)song

- (void) postDedication:(MTDedicationModel*)dedication toUser:(NSString*)userId completeHandler:(NetworkCompleteHandler)handler;
- (void) postDedication:(MTDedicationModel*)dedication toFBUser:(NSString*)fbId completeHandler:(NetworkCompleteHandler)handler;
- (void) getDedicationsFromUser:(NSString*)from toUser:(NSString*)to completeHandler:(NetworkCompleteHandler)handler;

- (void) postReadDedication:(MTDedicationModel*)dedication completeHandler:(NetworkCompleteHandler)handler;
@end
