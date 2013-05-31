//
//  MTMenuTableCell.h
//  MusTale
//
//  Created by Zenan on 31/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTMenuTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *iconImage;
@property (strong, nonatomic) IBOutlet UILabel *menuLabel;

-(void)setStyling;
@end
