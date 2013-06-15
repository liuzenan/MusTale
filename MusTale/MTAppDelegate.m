//
//  MTAppDelegate.m
//  MusTale
//
//  Created by Zenan on 30/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTAppDelegate.h"
#import "MTNetworkController.h"
#import "MTUserModel.h"
#import "MTItuneNetworkController.h"
@implementation MTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self customizeAppearance];
    
    return YES;
}

- (void) customizeAppearance
{
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];

    
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor],
      UITextAttributeTextColor,
      [UIColor clearColor],
      UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)],
      UITextAttributeTextShadowOffset,
      [UIFont fontWithName:LATO_BLACK size:19.0f],
      UITextAttributeFont,
      nil]];
    

    // Remove shadow from iOS6.0
    UINavigationBar *navBar = [[UINavigationBar alloc] init];
    if ([navBar respondsToSelector:@selector(shadowImage)]){
        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    }
        
     
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    /*[[MTItuneNetworkController sharedInstance] searchSongWithTerm:@"jack+johnson" completeHandler:^(id data, NSError *error) {
        NSArray* songs =(NSArray*)data;
    }];*/
    /*[[MTItuneNetworkController sharedInstance] getArtistSongsWithArtistId:@"909253" completeHandler:^(id data, NSError *error) {
        NSArray* songs = (NSArray*)data;
    }];
    */
    /*[[MTItuneNetworkController sharedInstance] getArtistWithArtistId:@"909253" completeHandler:^(id data, NSError *error) {
        NSArray* songs = (NSArray*)data;
    }];*/
    /*[[MTItuneNetworkController sharedInstance] getSongWithSongId:@"120954025" completeHandler:^(id data, NSError *error) {
        NSArray* songs = (NSArray*)data;
    }];*/
    /*
    MTUserModel* user = [MTUserModel new];
    user.ID = @"1";
    [[MTNetworkController sharedInstance] getUserWithID:user completeHandler:^(id data, NSError *error) {
        if (error) {
            NSLog(@"%@",[error localizedDescription]);
        } else {
            
        }
    }];*/
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
