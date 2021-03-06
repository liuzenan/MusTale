//
//  MTSongModel.h
//  MusTale
//
//  Created by Zenan on 30/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTItuneSongModel.h"
@interface MTSongModel : NSObject

@property (nonatomic, strong) NSString* ID;
@property (nonatomic) NSInteger listenCount;

@property (nonatomic, strong) NSString *trackName;
@property (nonatomic, strong) NSString *artistName;
@property (nonatomic, strong) NSString *trackId;
@property (nonatomic, strong) NSURL *trackViewUrl;
@property (nonatomic, strong) NSString *artistId;
@property (nonatomic, strong) NSURL *artworkUrl100;
@property (nonatomic, strong) NSString *collectionName;
@property (nonatomic, strong) NSString *collectionId;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSURL *previewUrl;
@property (nonatomic, strong) NSString *primaryGenreName;


@end
