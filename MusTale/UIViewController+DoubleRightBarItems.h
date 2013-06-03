//
//  UIViewController+DoubleRightBarItems.h
//  MusTale
//
//  Created by Zenan on 2/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kMenuButton,
    kSearchButton
} kNavBarRightItemType;

@interface UIViewController (DoubleRightBarItems)

- (void) setupRightNavBarItems;

@end
