//
//  UIViewController+DoubleRightBarItems.m
//  MusTale
//
//  Created by Zenan on 2/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "UIViewController+DoubleRightBarItems.h"


@implementation UIViewController (DoubleRightBarItems)


-(void)setupRightNavBarItems
{
    NSLog(@"setup right nav bar items");
    UIButton *search = [UIButton buttonWithType:UIButtonTypeCustom];
    [search setImage:[UIImage imageNamed:@"icon-search.png"] forState:UIControlStateNormal];
    [search sizeToFit];
    CGRect searchFrame = search.frame;
    NSLog(@"search frame: %@", NSStringFromCGRect(searchFrame));
    searchFrame.size.width += 20.0f;
    search.frame = searchFrame;
    [search setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc] initWithCustomView:search];
    [searchBtn setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [searchBtn setTag:kSearchButton];
    
    UIButton *menu = [UIButton buttonWithType:UIButtonTypeCustom];
    [menu setImage:[UIImage imageNamed:@"icon-menu.png"] forState:UIControlStateNormal];
    [menu sizeToFit];
    CGRect menuFrame = menu.frame;
    NSLog(@"menu frame: %@", NSStringFromCGRect(menuFrame));
    menuFrame.size.width += 20.0f;
    menu.frame = menuFrame;
    [menu setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *menuBtn = [[UIBarButtonItem alloc] initWithCustomView:menu];
    [menuBtn setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [menuBtn setTag:kMenuButton];
    
    NSArray *buttonArray = [NSArray arrayWithObjects:menuBtn, searchBtn, nil];
    [self.navigationItem setRightBarButtonItems:buttonArray];
}

@end
