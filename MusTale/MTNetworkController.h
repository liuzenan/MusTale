    //
//  MTNetworkController.h
//  MusTale
//
//  Created by Zenan on 30/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTNetworkController : NSObject

+ (void) testLoadSongWithResult:(void(^)(NSArray* songs))callback;

@end
