//
//  MTVoiceTaleView.h
//  MusTale
//
//  Created by Zenan on 13/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTVoiceTaleView : UIScrollView

@property (strong, nonatomic) IBOutlet UIImageView *profilePic;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *postDate;
@property (strong, nonatomic) IBOutlet UILabel *numLikes;
@property (strong, nonatomic) IBOutlet UILabel *numComments;
@property (strong, nonatomic) IBOutlet UIImageView *likeTale;
@property (strong, nonatomic) IBOutlet UIView *bottomDivider;
@property (strong, nonatomic) IBOutlet UIView *recordView;
@property (strong, nonatomic) IBOutlet UIButton *recordControlBtn;
@property (strong, nonatomic) IBOutlet UILabel *recordTimeCountDown;

- (IBAction)togglePlayVoice:(id)sender;
-(void)setStyling;
@end
