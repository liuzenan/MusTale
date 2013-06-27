//
//  MTInboxCell.h
//  MusTale
//
//  Created by Zenan on 27/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTInboxCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *profilePic;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *shortDedication;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UIView *contentWrapper;

-(void)setStyling;
@end
