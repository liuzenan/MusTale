//
//  MTTaleModel.h
//  MusTale
//
//  Created by Jiao Jing Ping on 16/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
//{"tale_id":"1","uid":"1","song_id":"3","text":"test","voice_url":"test","created_at":"2013-06-08 16:43:40"
@interface MTTaleModel : NSObject
@property (nonatomic,strong) NSString* ID;
@property (nonatomic,strong) NSString* userID;
@property (nonatomic,strong) NSString* songID;
@property (nonatomic,strong) NSString* text;
@property (nonatomic,strong) NSString* voiceUrl;
@property (nonatomic,strong) NSDate* createdAt;
@end