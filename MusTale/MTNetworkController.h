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
@interface MTNetworkController : NSObject

+ (MTNetworkController*) sharedInstance;
- (void) getUserWithID:(MTUserModel*)user completeHandler:(NetworkCompleteHandler)handler;
@end
