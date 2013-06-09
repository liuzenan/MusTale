//
//  MTPlaylistListViewController.h
//  MusTale
//
//  Created by Zenan on 30/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTPlaylistViewDelegate.h"
#import "MTSearchBarController.h"


@interface MTPlaylistListViewController : UITableViewController
@property (nonatomic, weak) id<MTPlaylistViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *gridButton;
@property (strong, nonatomic) MTSearchBarController *searchController;

- (IBAction)showGridView:(id)sender;


@end
