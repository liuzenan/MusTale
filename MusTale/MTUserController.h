//
//  MTUserController.h
//  MusTale
//
//  Created by Zenan on 30/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Facebook-iOS-SDK/FacebookSDK/FacebookSDK.h>
#import "MTUserModel.h"

@protocol FacebookLoginDelegate <NSObject>

- (void) facebookLoginSuccessWithExistingUser;
- (void) facebookLoginSuccessWithNewUser;
- (void) facebookLoginFailedWithError:(NSError *)error;

@end

@interface MTUserController : NSObject

@end
