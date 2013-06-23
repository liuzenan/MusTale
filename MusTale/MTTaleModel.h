//
//  MTTaleModel.h
//  MusTale
//
//  Created by Jiao Jing Ping on 16/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTUserModel.h"
//{"tale_id":"1","uid":"1","song_id":"3","text":"test","voice_url":"test","created_at":"2013-06-08 16:43:40"
@interface MTTaleModel : NSObject
@property (nonatomic,strong) NSString* ID;
@property (nonatomic,strong) NSString* songID;
@property (nonatomic,strong) NSString* text;
@property (nonatomic,strong) NSString* voiceUrl;
@property (nonatomic) BOOL isPublic;
@property (nonatomic) BOOL isAnonymous;
@property (nonatomic) BOOL isFront;
@property (nonatomic,strong) NSDate* createdAt;
@property (nonatomic,strong) MTUserModel* user;
@property (nonatomic) BOOL isLikedByCurrentUser;
@property (nonatomic) NSInteger likeCount;
@property (nonatomic) NSInteger commentCount;
@end
