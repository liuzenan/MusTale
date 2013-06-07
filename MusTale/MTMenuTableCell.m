//
//  MTMenuTableCell.m
//  MusTale
//
//  Created by Zenan on 31/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTMenuTableCell.h"
#import "UIColor+i7HexColor.h"
#import <QuartzCore/QuartzCore.h>

@implementation MTMenuTableCell

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
    [self.menuLabel setFont:[UIFont fontWithName:LATO_BOLD size:18.0f]];
    
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor colorWithHexString:FLAT_BLUE_HIGHLIGHT_COLOR]];
    [self setSelectedBackgroundView:bgColorView];
}

@end
