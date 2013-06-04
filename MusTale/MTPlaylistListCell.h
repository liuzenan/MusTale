//
//  MTPlaylistListCell.h
//  MusTale
//
//  Created by Zenan on 31/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTPlaylistListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *contentWrapper;
@property (strong, nonatomic) IBOutlet UIImageView *songCoverImage;
@property (strong, nonatomic) IBOutlet UILabel *songTitle;
@property (strong, nonatomic) IBOutlet UILabel *singerName;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

-(void) setStyling;

@end
