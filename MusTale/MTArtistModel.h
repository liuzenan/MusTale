//
//  MTArtistModel.h
//  MusTale
//
//  Created by Jiao Jing Ping on 15/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
/*"wrapperType":"artist", "artistType":"Artist", "artistName":"Jack Johnson", "artistLinkUrl":"https://itunes.apple.com/us/artist/jack-johnson/id909253?uo=4", "artistId":909253, "amgArtistId":468749, "primaryGenreName":"Rock", "primaryGenreId":21}]*/
@interface MTArtistModel : NSObject
@property (nonatomic,strong) NSString* artistType;
@property (nonatomic,strong) NSString* artistName;
@property (nonatomic,strong) NSString* artistLinkUrl;
@property (nonatomic,strong) NSString* artistId;
@end
