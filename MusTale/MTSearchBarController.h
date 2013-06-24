//
//  MTSearchBarController.h
//  MusTale
//
//  Created by Zenan on 4/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MTSearchBarDelegate

-(void)didLoadSearchResult:(NSArray*)result;

@end

@interface MTSearchBarController : UISearchDisplayController<UISearchBarDelegate>

@property (nonatomic, weak) id<MTSearchBarDelegate> searchBarDelegate;
- (void) setStyling;

@end
