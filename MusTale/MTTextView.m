//
//  MTTextView.m
//  MusTale
//
//  Created by Zenan on 11/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTTextView.h"

@implementation MTTextView

-(id)styleString
{
    return [[super styleString] stringByAppendingString:@"; line-height: 1.8em; margin-right: 22px; margin-left: 22px;"];
}

@end
