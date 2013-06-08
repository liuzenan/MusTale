//
//  MTSongView.m
//  MusTale
//
//  Created by Zenan on 5/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTSongView.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

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
        CGFloat scale = self.bounds.size.height / self.controlImage.bounds.size.height ;
        self.controlImage.transform = CGAffineTransformScale(self.controlImage.transform, scale / 8, scale / 8);
        self.controlImage.center = self.center;
        self.controlImage.alpha = 0.8;
        [self.superview addSubview:self.controlImage];
        
    } else if (state == kStatePause) {
        
        self.controlImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:DEFAULT_PAUSE_IMAGE]];
        CGFloat scale = self.bounds.size.height / self.controlImage.bounds.size.height ;
        self.controlImage.transform = CGAffineTransformScale(self.controlImage.transform, scale / 10, scale / 10);
        self.controlImage.center = self.center;
        [self.superview addSubview:self.controlImage];
        
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
//        roundCornerView.layer.borderColor = [UIColor whiteColor].CGColor;
//        roundCornerView.layer.borderWidth = 10.0f;
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
        self.middle = [[UIView alloc] initWithFrame:CGRectMake(self.center.x, self.center.y, self.radius / 2, self.radius / 2)];
        self.middle.layer.cornerRadius = self.radius / 4;
        self.middle.backgroundColor = [UIColor whiteColor];
        self.middle.layer.borderColor = [UIColor whiteColor].CGColor;
        self.middle.layer.borderWidth = 1;
        self.middle.alpha = 0.6;
        self.middle.center = self.center;
        
        self.middle.layer.shouldRasterize = YES;
        self.middle.layer.rasterizationScale = [[UIScreen mainScreen] scale];

        [self insertSubview:self.middle aboveSubview:roundCornerView];
    }
    
    return self;
}

- (void)didMoveToSuperview {
    [self addStateImage:kStateInit];
    [self setUpProgress];
}

@end
