//
//  MTReadTaleView.h
//  MusTale
//
//  Created by Zenan on 12/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OHAttributedLabel/OHAttributedLabel.h>

@interface MTTextTaleView : UIScrollView

@property (strong, nonatomic) IBOutlet UIImageView *profilePic;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *postDate;
@property (strong, nonatomic) IBOutlet UILabel *numLikes;
@property (strong, nonatomic) IBOutlet OHAttributedLabel *tale;
@property (strong, nonatomic) IBOutlet UILabel *numComments;
@property (strong, nonatomic) IBOutlet UIImageView *likeTale;
@property (strong, nonatomic) IBOutlet UIView *bottomDivider;

- (void)setText:(NSString*)text;
-(void)setStyling;

@end
