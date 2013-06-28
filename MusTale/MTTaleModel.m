//
//  MTTaleModel.m
//  MusTale
//
//  Created by Jiao Jing Ping on 16/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTTaleModel.h"

@implementation MTTaleModel

+ (MTTaleModel*) textTaleWithSongID:(NSString*)songID text:(NSString*)text isPublic:(BOOL)isPublic isAnonymous:(BOOL)isAnonymous {
    MTTaleModel* tale = [[MTTaleModel alloc] init];
    tale.songID = songID;
    tale.text =text;
    tale.isPublic = isPublic;
    tale.isAnonymous = isAnonymous;
    return tale;
}

@end
