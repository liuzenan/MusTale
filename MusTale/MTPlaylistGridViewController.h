//
//  MTPlaylistGridViewController.h
//  MusTale
//
//  Created by Zenan on 30/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "AQGridViewController.h"
#import "MTPlaylistViewDelegate.h"

@interface MTPlaylistGridViewController : AQGridViewController

@property (nonatomic, weak) id<MTPlaylistViewDelegate> delegate;

- (IBAction)showListView:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *listButton;



@end
