//
//  MTMenuViewController.m
//  MusTale
//
//  Created by Zenan on 30/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTMenuViewController.h"
#import "MTMenuTableCell.h"
#import "UIColor+i7HexColor.h"
#import "MTNetworkController.h"
#import "MTItuneNetworkController.h"
#define MENU_CELL_HEIGHT 60.0f

@interface MTMenuViewController (){
    BOOL disabled;
}
@end

@implementation MTMenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#2c3e50"];
    NSLog(@"menu did load");
    disabled = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    
    NSLog(@"menu did appear");
    if (currentSelected) {
        [self.tableView selectRowAtIndexPath:currentSelected animated:NO scrollPosition:UITableViewScrollPositionNone];
    } else {
        currentSelected =[NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView selectRowAtIndexPath:currentSelected animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return kMenuSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case kMenuSectionOthers:
            return kOthersSectionTypeCount;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuCell";
    MTMenuTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[MTMenuTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    
    NSString *labelString = @"";
    NSString *imageString = @"";

    if (indexPath.section == kMenuSectionOthers) {
        
        switch (indexPath.row) {
            case kOthersSectionTypeInbox:
                labelString = @"Inbox";
                imageString = @"icon-inbox";
                break;
            
            case kOthersSectionTypeOutbox:
                labelString = @"Outbox";
                imageString = @"icon-outbox";
                break;
                
            case kOthersSectionTypePopular:
                labelString = @"Popular";
                imageString = @"icon-popular";
                break;
            
            case kOthersSectionTypeFeatured:
                labelString = @"Featured";
                imageString = @"icon-featured";
                break;
            
            case kOthersSectionTypePlaylist:
                labelString = @"Playlist";
                imageString = @"icon-playlist";
                break;
            
            case kOthersSectionTypeLogout:
                labelString = @"Logout";
                imageString = @"icon-logout";
                break;
            default:
                labelString = @"Unknown";
                imageString = @"";
                break;
        }
    }
    
    [cell.iconImage setImage:[UIImage imageNamed:imageString]];
    [cell.menuLabel setText:labelString];
    [cell setStyling];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MENU_CELL_HEIGHT;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (disabled) {
        return;
    }
    
    disabled = YES;
    currentSelected = indexPath;
    
    if (indexPath.section == kMenuSectionOthers) {
        
        UIActionSheet *actionSheet;
        UINavigationController *viewController;
        
        switch (indexPath.row) {
                
            case kOthersSectionTypeInbox:
            {
                viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaylistList"];
                
                break;
            }
            case kOthersSectionTypeOutbox:
            {
                viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaylistList"];
                break;
            }
            case kOthersSectionTypePopular:
            {
                viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaylistList"];
                break;
            }
            case kOthersSectionTypeFeatured:
            {
                viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaylistList"];
                break;
            }
            case kOthersSectionTypePlaylist:
            {
                viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaylistList"];
                UIViewController *playlist = [self.storyboard instantiateViewControllerWithIdentifier:@"Playlist"];
                [viewController pushViewController:playlist animated:NO];
                break;
            }
            case kOthersSectionTypeLogout:
            {
                actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure to log out?"
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                            destructiveButtonTitle:@"Log Out"
                                                 otherButtonTitles:nil];
                [actionSheet showInView:self.view];
                break;
            }
            default:
                break;
        }
        
        if (viewController) {
            [self.slidingViewController anchorTopViewOffScreenTo:ECLeft animations:nil onComplete:^{
                CGRect frame = self.slidingViewController.topViewController.view.frame;
                self.slidingViewController.topViewController = viewController;
                self.slidingViewController.topViewController.view.frame = frame;
                [self.slidingViewController resetTopViewWithAnimations:nil onComplete:^{
                    disabled = NO;
                }];
            }];
        }
    }
}

#pragma mark - UIActionSheet Delegate

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    disabled = NO;
    if (buttonIndex == 0) {
       /*
        [[MTNetworkController sharedInstance] logout:^(id data, NSError *error) {
            if (!error){
                UIViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
                loginView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentModalViewController:loginView animated:YES];
            } else {
                // some error
            }
        }];*/
        /*
        [[MTItuneNetworkController sharedInstance] getSongWithSongId:@"171852806" completeHandler:^(id data, NSError *error) {
            
            if (!error){
                MTSongModel* song = [(NSArray*)data objectAtIndex:0];
                [[MTNetworkController sharedInstance] postListenTo:song completeHandler:^(id data, NSError *error) {
                    MTTaleModel* tale = [MTTaleModel new];
                    tale.isAnonymous=YES;
                    tale.isPublic = YES;
                    tale.text = @"Test tale";
                    tale.isFront = NO;
                    [[MTNetworkController sharedInstance] postTale:tale to:song completeHandler:^(id data, NSError *error) {
                        
                    }];
                }];
            }
        }];*/
        /*
        [[MTNetworkController sharedInstance] getPopularSongs:50 completeHandler:^(id data, NSError *error) {
           
        }];*/
        
        MTUserModel* user = [MTUserModel new];
        user.ID = @"28";
        [[MTNetworkController sharedInstance] getUserInfo:user completehandler:^(id data, NSError *error) {
            
        }];
        /*
        MTCommentsModel* comment = [MTCommentsModel new];
        comment.content = @"test";
        comment.taleID = @"10";
        [[MTNetworkController sharedInstance] postCommentToTale:comment completeHandler:^(id data, NSError *error) {
            
        }];*/
        NSString* taleID = @"10";
        [[MTNetworkController sharedInstance] likeTale:taleID compeleteHandler:^(id data, NSError *error) {
            
        }];
        
    }
}

@end
