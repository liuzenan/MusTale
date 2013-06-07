//
//  MTSongModel.m
//  MusTale
//
//  Created by Zenan on 30/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTSongModel.h"

@implementation MTSongModel

-(NSURL*)artworkUrl100
{
    return [NSURL URLWithString:[[_artworkUrl100 absoluteString] stringByReplacingOccurrencesOfString:@".100x100-75" withString:@".400x400-75"]];
}

@end
