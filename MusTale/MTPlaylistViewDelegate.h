//
//  MTPlaylistViewDelegate.h
//  MusTale
//
//  Created by Zenan on 1/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MTPlaylistViewDelegate

- (void) changedTopViewControllerToList;
- (void) changedTopViewControllerToGrid;

@end