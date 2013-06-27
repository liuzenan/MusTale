//
//  MTInboxOutboxViewController.h
//  MusTale
//
//  Created by Zenan on 23/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTPlaylistViewDelegate.h"

typedef enum{
    kInbox,
    kOutbox
} InboxOutboxType;

@interface MTInboxOutboxViewController : UITableViewController

@property (nonatomic, weak) id<MTPlaylistViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *dedications;

- (void) loadInboxDedications;
- (void) loadOutboxDedications;
- (void)setType:(InboxOutboxType)type;

@end
