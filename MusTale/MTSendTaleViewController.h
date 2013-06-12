//
//  MTSendTaleViewController.h
//  MusTale
//
//  Created by Zenan on 30/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCBlurredImageView.h"

@interface MTSendTaleViewController : UIViewController <UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIView *overlayView;
@property (strong, nonatomic) UIImage *bgImg;
@property (strong, nonatomic) RCBlurredImageView *bgImgView;
@end
