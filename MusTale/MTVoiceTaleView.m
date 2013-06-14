//
//  MTVoiceTaleView.m
//  MusTale
//
//  Created by Zenan on 13/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTVoiceTaleView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MTVoiceTaleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setStyling
{
    [self setContentInset:UIEdgeInsetsMake(20.0f, 0.0f, 20.0f, 0.0f)];
    [self.userName setFont:[UIFont fontWithName:LATO_BOLD size:16.0f]];
    [self.numLikes setFont:[UIFont fontWithName:LATO_REGULAR size:18.0f]];
    [self.postDate setFont:[UIFont fontWithName:LATO_REGULAR size:12.0f]];
    [self.recordTimeCountDown setFont:[UIFont fontWithName:LATO_REGULAR size:24.0f]];
    
    self.recordView.layer.masksToBounds = YES;
    self.recordView.layer.cornerRadius = 4.0f;
    self.recordView.layer.shouldRasterize = YES;
    self.recordView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    CGRect dividerFrame = self.bottomDivider.frame;
    dividerFrame.origin.y = self.recordView.frame.origin.y + self.recordView.frame.size.height + 20.0f;
    self.bottomDivider.frame = dividerFrame;
    
    CGRect commentsFrame = self.numComments.frame;
    commentsFrame.origin.y = self.bottomDivider.frame.origin.y + 16.0f;
    self.numComments.frame = commentsFrame;
    
    [self.numComments setFont:[UIFont fontWithName:LATO_REGULAR size:12.0f]];
    [self setContentSize:CGSizeMake(self.frame.size.width, CGRectGetMaxY(self.numComments.frame))];
    
    NSLog(@"content size: %@", NSStringFromCGSize(self.contentSize));
    
}


- (IBAction)togglePlayVoice:(id)sender {
}
@end
