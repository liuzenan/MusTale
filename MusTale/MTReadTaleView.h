//
//  MTReadTaleView.h
//  MusTale
//
//  Created by Zenan on 12/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTReadTaleView : UIScrollView

@property (strong, nonatomic) IBOutlet UIImageView *profilePic;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *postDate;
@property (strong, nonatomic) IBOutlet UILabel *numLikes;
@property (strong, nonatomic) IBOutlet UILabel *tale;
@property (strong, nonatomic) IBOutlet UILabel *numComments;
@property (strong, nonatomic) IBOutlet UIImageView *likeTale;

- (void)setText:(NSString*)text;
-(void)setStyling;

@end
