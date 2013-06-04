//
//  MTPlaylistGridViewController.h
//  MusTale
//
//  Created by Zenan on 30/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "AQGridViewController.h"
#import "MTPlaylistViewDelegate.h"
#import "MTSearchBarController.h"

@interface MTPlaylistGridViewController : AQGridViewController

@property (nonatomic, weak) id<MTPlaylistViewDelegate> delegate;
@property (strong, nonatomic) MTSearchBarController *searchController;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *listButton;


- (IBAction)showListView:(id)sender;


@end
