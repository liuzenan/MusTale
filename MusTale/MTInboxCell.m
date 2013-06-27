//
//  MTInboxCell.m
//  MusTale
//
//  Created by Zenan on 27/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTInboxCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation MTInboxCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setStyling
{
    [self.userName setFont:[UIFont fontWithName:LATO_BOLD size:20.0f]];
    [self.shortDedication setFont:[UIFont fontWithName:LATO_REGULAR size:14.0f]];
    [self.date setFont:[UIFont fontWithName:LATO_REGULAR size:12.0f]];
    self.date.textColor = [UIColor darkGrayColor];
    [self.contentWrapper.layer setCornerRadius:4.0f];
    // border
    [self.contentWrapper.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.contentWrapper.layer setBorderWidth:0.4f];
    
    self.contentWrapper.layer.shouldRasterize = YES;
    self.contentWrapper.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}

@end
