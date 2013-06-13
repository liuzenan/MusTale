//
//  MTReadTaleView.m
//  MusTale
//
//  Created by Zenan on 12/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTTextTaleView.h"

@implementation MTTextTaleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setText:(NSString*)text
{
    [self.tale setText:text];
}

-(void)setStyling
{
    [self setContentInset:UIEdgeInsetsMake(20.0f, 0.0f, 20.0f, 0.0f)];
    [self.userName setFont:[UIFont fontWithName:LATO_BOLD size:18.0f]];
    [self.postDate setFont:[UIFont fontWithName:LATO_REGULAR size:14.0f]];
    [self.tale setFont:[UIFont fontWithName:LATO_REGULAR size:16.0f]];
    self.tale.lineBreakMode = NSLineBreakByWordWrapping;
    self.tale.numberOfLines = 0;
    CGRect currentFrame = self.tale.frame;
    CGSize max = CGSizeMake(self.tale.frame.size.width, 500);
    CGSize expected = [self.tale.text sizeWithFont:self.tale.font constrainedToSize:max lineBreakMode:self.tale.lineBreakMode];
    currentFrame.size.height = expected.height;
    self.tale.frame = currentFrame;
    CGRect commentFrame = self.numComments.frame;
    commentFrame.origin.y = self.tale.frame.origin.y + self.tale.frame.size.height;
    self.numComments.frame = commentFrame;
    
    [self.numComments setFont:[UIFont fontWithName:LATO_REGULAR size:14.0f]];
    [self setContentSize:CGSizeMake(self.frame.size.width, CGRectGetMaxY(self.numComments.frame))];
    NSLog(@"content size: %@", NSStringFromCGSize(self.contentSize));
    
    
}

@end
