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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)removeStateImage {
    if (self.controlImage) {
        [self.controlImage removeFromSuperview];
        self.controlImage = nil;
    }
}

- (void)setUpProgress {
    self.progress = [MTProgressView progressViewWithRadius:self.radius];
    self.progress.frame = self.frame;
    self.progress.layer.cornerRadius = self.radius;
    self.progress.transform = CGAffineTransformMakeScale(1.1, 1.1);
    self.progress.alpha = 0.2;
    [self.superview insertSubview:self.progress belowSubview:self];
}

- (void)hideProgressBar {
    [UIView animateWithDuration:2
                          delay:5.0
                        options:(UIViewAnimationCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         self.progress.layer.opacity = 0.1;
                     }completion:^(BOOL finished){
                         
                     }];
}

- (void)showProgressBar {
    if (self.progress.alpha != 1) {
        [UIView animateWithDuration:1
                              delay:0.0
                            options:(UIViewAnimationCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction)
                         animations:^{
                             self.progress.alpha = 0.8;
                         }completion:^(BOOL finished){
                             
                         }];
        
        [self hideProgressBar];
    }
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
        
    } else if (state == kStateStop) {
        
        self.controlImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:DEFAULT_STOP_IMAGE]];
        CGFloat scale = self.bounds.size.height / self.controlImage.bounds.size.height ;
        self.controlImage.transform = CGAffineTransformScale(self.controlImage.transform, scale / 8, scale / 8);
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
        roundCornerView.contentMode = UIViewContentModeScaleAspectFill;
        roundCornerView.backgroundColor = [UIColor lightGrayColor];
        
        roundCornerView.layer.shouldRasterize = YES;
        roundCornerView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowRadius = 2.0;
        self.backgroundColor = [UIColor clearColor];
        self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        self.layer.shadowOpacity = 0.9f;
        [self addSubview:roundCornerView];
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        
        self.middle = [[UIView alloc] initWithFrame:CGRectMake(self.center.x, self.center.y, self.radius / 2, self.radius / 2)];
        self.middle.layer.cornerRadius = self.radius / 4;
        self.middle.backgroundColor = [UIColor whiteColor];
        self.middle.layer.borderColor = [UIColor whiteColor].CGColor;
        self.middle.layer.borderWidth = 1;
        self.middle.alpha = 1;
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
