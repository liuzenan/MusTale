//
//  MTSongView.h
//  MusTale
//
//  Created by Zenan on 5/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CoreAnimation.h>
#import <QuartzCore/QuartzCore.h>
#import "MTProgressView.h"
#import "MTConstants.h"

typedef enum {kStateInit, kStatePause} PlayState;

@interface MTSongView : UIView

@property (nonatomic,strong) UIImageView *controlImage;
@property (nonatomic,strong) MTProgressView *progress;
@property (nonatomic,strong) UIView *middle;

- (id) initWithURLAndRadius:(NSURL*)url Radius:(CGFloat)p_radius;
- (void)addStateImage:(PlayState)state;
- (void)removeStateImage;

@end
