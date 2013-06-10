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
#import "MTControlCircle.h"

typedef enum {kStateInit, kStatePause} PlayState;
typedef enum {kControlStateOff, kControlStateOn} ControlState;

@interface MTSongView : UIView

@property (nonatomic,strong) UIImageView *controlImage;
@property (nonatomic,strong) UIImageView *controlCircleButtonImage;
@property (nonatomic,strong) MTProgressView *progress;
@property (nonatomic,strong) UIView *leftControl;
@property (nonatomic,strong) UIView *rightControl;
@property (nonatomic,strong) MTControlCircle *circleView;

- (id) initWithURLAndRadius:(NSURL*)url Radius:(CGFloat)p_radius;
- (void)addStateImage:(PlayState)state;
- (void)addControlButtonImage:(ControlState)state;
- (void)removeStateImage;
- (CGFloat)radius;

@end
