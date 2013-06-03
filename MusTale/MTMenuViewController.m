//
//  MTMenuViewController.m
//  MusTale
//
//  Created by Zenan on 30/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTMenuViewController.h"
#import "MTMenuTableCell.h"

#define MENU_CELL_HEIGHT 60.0f

@interface MTMenuViewController ()

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
    self.view.backgroundColor = [UIColor darkGrayColor];

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
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MENU_CELL_HEIGHT;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
            CGRect frame = self.slidingViewController.topViewController.view.frame;
            self.slidingViewController.topViewController = viewController;
            self.slidingViewController.topViewController.view.frame = frame;
            [self.slidingViewController resetTopView];
        }
    }
}

#pragma mark - UIActionSheet Delegate

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 0) {
        UIViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
        loginView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentModalViewController:loginView animated:YES];
    }
}

@end
