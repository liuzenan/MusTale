//
//  MTDedicationViewController.h
//  MusTale
//
//  Created by Zenan on 27/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OHAttributedLabel/OHAttributedLabel.h>
#import "MTDedicationModel.h"


@interface MTDedicationViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *profilePic;
- (IBAction)togglePlay:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet OHAttributedLabel *textTale;
@property (strong, nonatomic) IBOutlet UILabel *commentsCount;
@property (strong, nonatomic) IBOutlet UIView *bottomSeparator;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) MTDedicationModel *currentDedication;
- (void)setCurrentTale:(MTDedicationModel*)dedication;
- (void) setStyling;
@end
