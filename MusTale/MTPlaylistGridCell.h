//
//  MTPlaylistGridCell.h
//  MusTale
//
//  Created by Zenan on 31/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "AQGridViewCell.h"

@interface MTPlaylistGridCell : UIView
@property (strong, nonatomic) IBOutlet UIImageView *coverImage;
@property (strong, nonatomic) IBOutlet UILabel *songLabel;

- (void) setStyling;

@end
