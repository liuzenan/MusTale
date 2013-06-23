//
//  MTTaleController.m
//  MusTale
//
//  Created by Zenan on 23/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTTaleController.h"

@implementation MTTaleController

+ (MTTaleController*) sharedInstance
{
    static MTTaleController *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[MTTaleController alloc] init];
    });
    
    return __sharedInstance;
}

@end
