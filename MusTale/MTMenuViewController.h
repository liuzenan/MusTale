//
//  MTMenuViewController.h
//  MusTale
//
//  Created by Zenan on 30/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"

typedef enum {
    kMenuSectionOthers,
    kMenuSectionCount
} kMenuSection;

typedef enum {
    kOthersSectionTypeInbox,
    kOthersSectionTypeOutbox,
    kOthersSectionTypePopular,
    kOthersSectionTypeFeatured,
    kOthersSectionTypePlaylist,
    kOthersSectionTypeLogout,
    kOthersSectionTypeCount
} kOthersSectionType;

@interface MTMenuViewController : UITableViewController<UIActionSheetDelegate>{
    NSIndexPath *currentSelected;
}

@end
