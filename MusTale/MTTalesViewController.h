//
//  MTTalesViewController.h
//  MusTale
//
//  Created by Zenan on 30/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTTalesViewController : UIViewController <UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *taleScrollView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backbtn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuBtn;
@property (strong, nonatomic) IBOutlet UIToolbar *commentBar;
@property (strong, nonatomic) IBOutlet UITextField *commentField;

@end
