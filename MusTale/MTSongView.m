//
//  MTSongView.m
//  MusTale
//
//  Created by Zenan on 5/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTSongView.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UIColor+i7HexColor.h"

@interface MTSongView ()
@property (nonatomic) CGFloat radius;
@end

@implementation MTSongView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)removeStateImage {
    if (self.controlImage) {
        [self.controlImage removeFromSuperview];
        self.controlImage = nil;
    }
}

- (void)setUpProgress {
    self.progress = [MTProgressView progressViewWithRadius:self.radius];
    CGRect frame = self.frame;
    frame.size.width = frame.size.height = (self.radius + PROGRESS_VIEW_WIDTH) * 2;
    self.progress.frame = frame;
    [self.progress setCenter:self.center];
    self.progress.layer.cornerRadius = (self.radius + PROGRESS_VIEW_WIDTH);
    self.progress.alpha = 1.0;
    [self.superview insertSubview:self.progress belowSubview:self];
}

- (void)addStateImage:(PlayState)state {
    
    
    if (self.controlImage) {
        [self.controlImage removeFromSuperview];
        self.controlImage = nil;
    }
    
    if (state == kStateInit) {
        self.controlImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:DEFAULT_PLAY_IMAGE]];
        self.controlImage.center = CGPointMake(CGRectGetMidX(self.leftControl.bounds), CGRectGetMidY(self.leftControl.bounds));
        [self.leftControl addSubview:self.controlImage];
        
    } else if (state == kStatePause) {
        
        self.controlImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:DEFAULT_PAUSE_IMAGE]];
        self.controlImage.center = CGPointMake(CGRectGetMidX(self.leftControl.bounds), CGRectGetMidY(self.leftControl.bounds));
        [self.leftControl addSubview:self.controlImage];
        
    }
}

- (void)addControlButtonImage:(ControlState)state Animated:(BOOL)animated
{
    
    if (!self.controlCircleButtonImage) {
        self.controlCircleButtonImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:DEFAULT_PLUS_IMAGE]];
        self.controlCircleButtonImage.center = CGPointMake(CGRectGetMidX(self.rightControl.bounds), CGRectGetMidY(self.rightControl.bounds));
        [self.rightControl addSubview:self.controlCircleButtonImage];
    }
    
    if (state == kControlStateOff) {
        if (animated) {
            [UIView animateWithDuration:0.2f animations:^{
                [self.controlCircleButtonImage setTransform:CGAffineTransformMakeRotation(0.0f)];
            }];
        } else {
            [self.controlCircleButtonImage setTransform:CGAffineTransformMakeRotation(0.0f)];
        }
        
        [self.circleView hideControlCircle:animated];
    } else if (state == kControlStateOn) {
        if (animated) {
            [UIView animateWithDuration:0.2f animations:^{
                [self.controlCircleButtonImage setTransform:CGAffineTransformMakeRotation(M_PI_4)];
            }];
        } else {
            [self.controlCircleButtonImage setTransform:CGAffineTransformMakeRotation(M_PI_4)];
        }
        [self.circleView showControlCircle:animated];
    }
}

- (id) initWithURLAndRadius:(NSURL*)url Radius:(CGFloat)p_radius {
    
    if (self = [self initWithFrame:CGRectMake(0, 0, p_radius * 2, p_radius * 2)]) {
        
        self.radius = p_radius;
        
        
        UIImageView *roundCornerView = [[UIImageView alloc] initWithFrame:self.frame];
        [roundCornerView setImageWithURL:url];
        roundCornerView.layer.masksToBounds = YES;
        roundCornerView.layer.opaque = NO;
        roundCornerView.layer.cornerRadius = self.radius;
        roundCornerView.layer.borderColor = [UIColor colorWithHexString:MUSIC_BG_COLOR].CGColor;
        roundCornerView.layer.borderWidth = 0.5f;
        roundCornerView.contentMode = UIViewContentModeScaleAspectFill;
        roundCornerView.backgroundColor = [UIColor darkGrayColor];
        
        roundCornerView.layer.shouldRasterize = YES;
        roundCornerView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        
//        self.layer.shadowColor = [UIColor blackColor].CGColor;
//        self.layer.shadowRadius = 2.0;
//        self.backgroundColor = [UIColor clearColor];
//        self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
//        self.layer.shadowOpacity = 0.9f;
//        [self addSubview:roundCornerView];
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        
        [self addSubview:roundCornerView];

    }
    
    return self;
}

-(CGFloat)radius
{
    return _radius;
}

- (void) setUpControlButtons
{
    UIImageView *cdCenter = [[UIImageView alloc] initWithImage:[UIImage imageNamed:DEFAULT_CD_CENTER_IMAGE]];
    cdCenter.center = self.center;
    
    self.leftControl = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CONTROL_BUTTON_RADIUS*2, CONTROL_BUTTON_RADIUS*2)];
    self.leftControl.layer.cornerRadius = CONTROL_BUTTON_RADIUS;
    self.leftControl.backgroundColor = [UIColor whiteColor];
    self.leftControl.layer.borderColor = [UIColor whiteColor].CGColor;
    self.leftControl.layer.borderWidth = 1;
    self.leftControl.alpha = 1.0f;
    self.leftControl.center = CGPointMake(self.center.x - self.radius * 0.5f,
                                          self.frame.origin.y + self.frame.size.height);
    
    self.leftControl.layer.shouldRasterize = YES;
    self.leftControl.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.rightControl = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CONTROL_BUTTON_RADIUS*2, CONTROL_BUTTON_RADIUS*2)];
    self.rightControl.layer.cornerRadius = CONTROL_BUTTON_RADIUS;
    self.rightControl.backgroundColor = [UIColor whiteColor];
    self.rightControl.layer.borderColor = [UIColor whiteColor].CGColor;
    self.rightControl.layer.borderWidth = 1;
    self.rightControl.alpha = 1.0f;
    self.rightControl.center = CGPointMake(self.center.x + self.radius * 0.5f,
                                           self.frame.origin.y + self.frame.size.height);
    
    self.rightControl.layer.shouldRasterize = YES;
    self.rightControl.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.circleView = [[MTControlCircle alloc] initWithRadius:self.radius + OUTER_CIRCLE_WIDTH];
    [self.circleView setCenter:self.center];
    
    [self.superview insertSubview:cdCenter aboveSubview:self];
    [self.superview insertSubview:self.leftControl aboveSubview:cdCenter];
    [self.superview insertSubview:self.rightControl aboveSubview:cdCenter];
    [self.superview insertSubview:self.circleView belowSubview:self];
}

- (void)didMoveToSuperview {
    [self setUpControlButtons];
    [self addStateImage:kStateInit];
    [self addControlButtonImage:kControlStateOff Animated:NO];
    [self setUpProgress];
}

@end
