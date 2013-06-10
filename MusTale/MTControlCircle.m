//
//  MTControlCircle.m
//  MusTale
//
//  Created by Zenan on 9/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTControlCircle.h"
#import <QuartzCore/QuartzCore.h>


@implementation MTControlCircle

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

- (id) initWithRadius:(CGFloat) radius
{
    if (self = [self initWithFrame:CGRectMake(0, 0, radius*2, radius*2)]){
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = radius;
        self.layer.masksToBounds = YES;
        self.alpha = 0.0f;
        self.opaque = NO;
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    }
    
    return self;
}

- (void)showControlCircle
{
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 0.4f;
    }];
}

-(void)hideControlCircle
{
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 0.0f;
    }];
}

@end
