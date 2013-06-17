//
//  MTItuneSongModel.m
//  MusTale
//
//  Created by Jiao Jing Ping on 18/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTItuneSongModel.h"

@implementation MTItuneSongModel
-(NSURL*)artworkUrl100
{
    return [NSURL URLWithString:[[_artworkUrl100 absoluteString] stringByReplacingOccurrencesOfString:@".100x100-75" withString:@".400x400-75"]];
}

@end
