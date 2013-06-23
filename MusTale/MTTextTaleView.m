//
//  MTReadTaleView.m
//  MusTale
//
//  Created by Zenan on 12/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTTextTaleView.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

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
    NSMutableAttributedString *str = [NSMutableAttributedString attributedStringWithString:text];
    [str setFont:[UIFont fontWithName:LATO_REGULAR size:14.0f]];
    
    OHParagraphStyle* paragraphStyle = [OHParagraphStyle defaultParagraphStyle];
    paragraphStyle.lineSpacing = 5.f; // increase space between lines by 5 points
    paragraphStyle.paragraphSpacingBefore = 20.0f;
    [str setParagraphStyle:paragraphStyle];
    [str setTextAlignment:kCTTextAlignmentNatural lineBreakMode:kCTLineBreakByWordWrapping];
    
    [self.tale setAttributedText:str];
}

- (void)setCurrentTale:(MTTaleModel*)tale
{
    [self.userName setText:tale.user.name];
    [self.numLikes setText:[NSString stringWithFormat:@"%d", tale.likeCount]];
    [self.numComments setText:[NSString stringWithFormat:@"%d comments", tale.commentCount]];
    [self setText:tale.text];
    [self.profilePic setImageWithURL:[NSURL URLWithString:tale.user.profileURL]];
    
}

-(void)setStyling
{
    [self setContentInset:UIEdgeInsetsMake(20.0f, 0.0f, 20.0f, 0.0f)];
    [self.userName setFont:[UIFont fontWithName:LATO_BOLD size:16.0f]];
    [self.numLikes setFont:[UIFont fontWithName:LATO_REGULAR size:18.0f]];
    [self.postDate setFont:[UIFont fontWithName:LATO_REGULAR size:12.0f]];
    CGRect currentFrame = self.tale.frame;
    CGSize max = CGSizeMake(self.tale.frame.size.width, INFINITY);
    CGSize expected = [self.tale.attributedText sizeConstrainedToSize:max];
    currentFrame.size.height = expected.height;
    self.tale.frame = currentFrame;
    
    CGRect dividerFrame = self.bottomDivider.frame;
    dividerFrame.origin.y = self.tale.frame.origin.y + self.tale.frame.size.height + 20.0f;
    self.bottomDivider.frame = dividerFrame;
    
    CGRect commentsFrame = self.numComments.frame;
    commentsFrame.origin.y = self.bottomDivider.frame.origin.y + 16.0f;
    self.numComments.frame = commentsFrame;
    
    [self.numComments setFont:[UIFont fontWithName:LATO_REGULAR size:12.0f]];
    [self setContentSize:CGSizeMake(self.frame.size.width, CGRectGetMaxY(self.numComments.frame))];
    
    NSLog(@"content size: %@", NSStringFromCGSize(self.contentSize));
    
}

@end
