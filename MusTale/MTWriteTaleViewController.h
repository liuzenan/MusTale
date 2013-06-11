//
//  MTWriteTaleViewController.h
//  MusTale
//
//  Created by Zenan on 10/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTTextView.h"
#import "MTSongModel.h"

@interface MTWriteTaleViewController : UIViewController

@property (nonatomic, strong) MTSongModel *currentSong;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelBtn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *confirmBtn;
@property (strong, nonatomic) IBOutlet MTTextView *taleTextView;

@end
