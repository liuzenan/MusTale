//
//  MTItuneSongModel.h
//  MusTale
//
//  Created by Jiao Jing Ping on 18/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTItuneSongModel : NSObject

@property (nonatomic, strong) NSString* ID;
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
