//
//  MTSearchBarController.m
//  MusTale
//
//  Created by Zenan on 4/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTSearchBarController.h"
#import "MTConstants.h"
#import "MTItuneNetworkController.h"
#import "MTPlaylistListCell.h"
#import "MTPlaylistGridCell.h"
#import <QuartzCore/QuartzCore.h>
#import "MTSongModel.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation MTSearchBarController

-(void)setStyling
{
    
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    NSLog(@"search bar button clicked");
    [[MTItuneNetworkController sharedInstance] searchSongWithTerm:searchBar.text completeHandler:^(id data, NSError *error) {
        if (!error) {
            NSLog(@"data: %@", data);
            [self.searchBarDelegate didLoadSearchResult:data];
        } else {
            NSLog(@"error: %@", error);
        }
    }];
    
}

@end
