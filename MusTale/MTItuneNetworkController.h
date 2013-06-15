//
//  MTItuneController.h
//  MusTale
//
//  Created by Jiao Jing Ping on 15/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTItuneNetworkController : NSObject
+ (MTItuneNetworkController*) sharedInstance;

- (void) searchSongWithTerm:(NSString*)term completeHandler:(NetworkCompleteHandler)handler;

- (void) getArtistSongsWithArtistId:(NSString*)artistId completeHandler:(NetworkCompleteHandler)handler;

- (void) getArtistWithArtistId:(NSString*)artistId completeHandler:(NetworkCompleteHandler)handler;

- (void) getSongWithSongId:(NSString*)songId completeHandler:(NetworkCompleteHandler)handler;

- (void) testLoadSongWithResult:(void(^)(NSArray* success))callback;
@end
