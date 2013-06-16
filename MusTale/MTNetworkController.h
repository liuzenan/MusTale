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
@interface MTNetworkController : NSObject
@property (nonatomic,strong) MTUserModel* currentUser;
+ (MTNetworkController*) sharedInstance;
- (BOOL) isLoggedIn;
- (void) fbLogin:(FBLoginCompleteHandler)completeHandler;
- (void) signUpViaFacebook:(NetworkCompleteHandler)handler;
- (void) logout:(NetworkCompleteHandler)completeHandler;

- (void) getUserWithID:(MTUserModel*)user completeHandler:(NetworkCompleteHandler)handler;

@end
