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
#import "MTFBHelper.h"
#import "MTS3Controller.h"
#import "MTFBFriendPickerViewController.h"
#import "MTInboxOutboxViewController.h"
#define MENU_CELL_HEIGHT 60.0f

@interface MTMenuViewController (){
    BOOL disabled;
    MTFBFriendPickerViewController* fbpickerVC;
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
            
//            case kOthersSectionTypePlaylist:
//                labelString = @"Playlist";
//                imageString = @"icon-playlist";
//                break;
            
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
                viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Inbox"];
                MTInboxOutboxViewController *inbox = (MTInboxOutboxViewController*) viewController.topViewController;
                [inbox setType:kInbox];
                break;
            }
            case kOthersSectionTypeOutbox:
            {
                viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Inbox"];
                MTInboxOutboxViewController *outbox = (MTInboxOutboxViewController*) viewController.topViewController;
                [outbox setType:kOutbox];
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
//            case kOthersSectionTypePlaylist:
//            {
//                viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaylistList"];
//                UIViewController *playlist = [self.storyboard instantiateViewControllerWithIdentifier:@"Playlist"];
//                [viewController pushViewController:playlist animated:NO];
//                break;
//            }
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
        BOOL testing = YES;
        [[MTItuneNetworkController sharedInstance] getSongWithSongId:@"171852806" completeHandler:^(id data, NSError *error) {
            
            if (!error){
                MTSongModel* song = [(NSArray*)data objectAtIndex:0];
                
                [[MTNetworkController sharedInstance] postListenTo:song completeHandler:^(id data, NSError *error) {
                    MTTaleModel* tale = [MTTaleModel new];
                    tale.isAnonymous=YES;
                    tale.isPublic = YES;
                    tale.text = @"Test tale";
                    tale.isFront = NO;
                    NSError* err;
                    NSData* soundData = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/MySound.caf", DOCUMENTS_FOLDER] options: 0 error:&err];
                    [[MTNetworkController sharedInstance] postVoiceTale:soundData tale:tale to:song completeHandler:^(id data, NSError *error){
                        
                    }];
                }];
            } else {
                NSLog(@"Error %@",error);
            }
        }];
        
        /*
        [[MTNetworkController sharedInstance] getDedicationsFromUser:nil toUser:@"28" completeHandler:^(id data, NSError *error) {
            MTDedicationModel* dedication = [data objectAtIndex:0];
            [[MTNetworkController sharedInstance] postReadDedication:dedication completeHandler:^(id data, NSError *error) {
                
            }];
        }];
         */

        if (!testing){
        [[MTNetworkController sharedInstance] logout:^(id data, NSError *error) {
            if (!error){
                UIViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
                loginView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentModalViewController:loginView animated:YES];
            } else {
                // some error
            }
        }];
        }

        /*
        NSError* err;
        NSData* soundData = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/MySound.caf", DOCUMENTS_FOLDER] options: 0 error:&err];
        [[MTS3Controller sharedInstance] uploadSoundToS3Bucket:soundData Completion:^(BOOL success, NSString *soundPath) {
            NSLog(@"%@",soundPath);
            [[MTS3Controller sharedInstance] getSoundURLByFilePath:soundPath Completion:^(NSURL *url, NSError *error) {
                NSLog(@"%@",url);
            }];
        }];
        fbpickerVC = [[MTFBFriendPickerViewController alloc] init];
        [self presentViewController:fbpickerVC animated:YES completion:nil];*/
        /* Send dedication,return the same dedication model
        MTDedicationModel* dedication = [MTDedicationModel new];
        dedication.taleId = @"10";
        dedication.isPublic = YES;
        dedication.isAnonymous = NO;
        [[MTNetworkController sharedInstance] postDedication:dedication toUser:@"29" completeHandler:^(id data, NSError *error) {
            
        }];*/
        // get my inbox, return list of dedication
        /*[[MTNetworkController sharedInstance] getDedicationsFromUser:nil toUser:@"28" completeHandler:^(id data, NSError *error) {
            
        }];
        // get my outbox,return list of dedication

        [[MTNetworkController sharedInstance] getDedicationsFromUser:@"28" toUser:nil completeHandler:^(id data, NSError *error) {
            
        }];*/
        /*[[MTFBHelper sharedFBHelper] searchFriendMatchingTerm:@"jim" completeHandler:^(id data, NSError *error) {
                
        }];*/
        
        /*API Examples*/
       /*
                
         // Get song info from itune and register the song to the server, return the same song model with songId filled.
         // Then post a tale to this song
        */
     
        /*
         // Get popular song with limit 50
        [[MTNetworkController sharedInstance] getPopularSongs:50 completeHandler:^(id data, NSError *error) {
           
        }];*/
        /*
         // Get a infomation of a user given its ID, return the same model with info filled
        MTUserModel* user = [MTUserModel new];
        user.ID = @"28";
        [[MTNetworkController sharedInstance] getUserInfo:user completehandler:^(id data, NSError *error) {
            
        }];*/
        /*
         // Post comment to a tale, return the same comments model with info filled
        MTCommentsModel* comment = [MTCommentsModel new];
        comment.content = @"test";
        comment.taleID = @"10";
        [[MTNetworkController sharedInstance] postCommentToTale:comment completeHandler:^(id data, NSError *error) {
            
        }];*/
        /*
         // like a tale, return the count of like for the tale as NSInteger
        NSString* taleID = @"10";
        [[MTNetworkController sharedInstance] likeTale:taleID compeleteHandler:^(id data, NSError *error) {
            
        }];
         [[MTNetworkController sharedInstance] unlikeTale:taleID compeleteHandler:^(id data, NSError *error) {
         
         }];*/
        
        /*
         // Get tales of a song, return array of tales model
        [[MTNetworkController sharedInstance] getTalesOfSong:@"5" completeHandler:^(id data, NSError *error) {
            
        }];*/
        
        /*
         // Get comments of a tale, return array of comment model
         [[MTNetworkController sharedInstance] getCommentsOfTale:@"11" completeHandler:^(id data, NSError *error) {
             
         }];*/
        
        
         
    }
}

@end
