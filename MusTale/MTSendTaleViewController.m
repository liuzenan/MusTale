//
//  MTSendTaleViewController.m
//  MusTale
//
//  Created by Zenan on 30/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTSendTaleViewController.h"
#import <FacebookSDK/Facebook.h>
#import "MTFBHelper.h"
@interface MTSendTaleViewController () <FBFriendPickerDelegate,UISearchBarDelegate>
@property (strong, nonatomic) FBFriendPickerViewController* friendPickerController;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSString *searchText;
@end

@implementation MTSendTaleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setStyling];
    self.bgImgView = [[RCBlurredImageView alloc] initWithImage:self.bgImg];
    [self.view insertSubview:self.bgImgView belowSubview:self.overlayView];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tapGes.numberOfTapsRequired = 1;
    tapGes.delegate = self;
    [self.bgImgView setUserInteractionEnabled:YES];
    [self.bgImgView addGestureRecognizer:tapGes];
    
}

- (void)dismiss
{
    
    [UIView animateWithDuration:0.6f animations:^{
        [self setInitialStyle];
    } completion:^(BOOL finished) {
        [self dismissModalViewControllerAnimated:NO];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [self setInitialStyle];
    [super viewWillAppear:animated];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.6f animations:^{
        [self setFinalStyle];
//        [self showFriendList];
    }];
}

-(void)setFinalStyle
{
    CGRect frame = self.overlayView.frame;
    frame.origin.y = self.view.frame.size.height - frame.size.height;
    self.overlayView.frame = frame;
    [self.bgImgView setBlurIntensity:1.0f];
}

-(void)setInitialStyle
{
    CGRect frame = self.overlayView.frame;
    frame.origin.y = self.view.frame.size.height;
    self.overlayView.frame = frame;
    [self.bgImgView setBlurIntensity:0.0f];
}

-(void) setStyling
{
    [self.overlayView setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.7]];
    [self.searchBar setBackgroundImage:[UIImage new]];
    [self.searchBar setTintColor:[UIColor clearColor]];
    [self.searchBar setTranslucent:YES];
    for (id v in [self.searchBar subviews]) {
        if (![v isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
            [v setAlpha:0.0f];
            [v setHidden:YES];
        }
        else {
            [v setBackgroundColor:[UIColor clearColor]];
        }
    }
}

- (void)viewDidUnload {
    [self setOverlayView:nil];
    [self setSearchBar:nil];
    [self setFriendsListTable:nil];
    [super viewDidUnload];
}

- (IBAction)sendTale:(id)sender {
    [self.delegate sendCurrentTale];
}

- (IBAction)cancel:(id)sender {
    [self dismiss];
}




//- (void) showFriendList
//{
//    if (![[MTFBHelper sharedFBHelper] isOpen]) {
//        [[MTFBHelper sharedFBHelper] openSessionWithAllowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
//            [self insertFriendTable];
//        }];
//    } else {
//        [self insertFriendTable];
//    }
//}
//
//
//- (void) insertFriendTable {
//    
//    
//    if (self.friendPickerController == nil) {
//        // Create friend picker, and get data loaded into it.
//        self.friendPickerController = [[FBFriendPickerViewController alloc] init];
//        self.friendPickerController.title = @"Select Friends";
//        self.friendPickerController.delegate = self;
//    }
//    NSLog(@"friendpicker controller: %@", self.friendPickerController);
//    [self.friendPickerController loadData];
//    [self.friendPickerController clearSelection];
//    [self.friendPickerController loadView];
//    self.friendsListTable = self.friendPickerController.tableView;
//    NSLog(@"friedns list table:%@", self.friendsListTable);
//}



- (IBAction)fbBtnPressed:(id)sender {
        if (![[MTFBHelper sharedFBHelper] isOpen]) {
            [[MTFBHelper sharedFBHelper] openSessionWithAllowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                [self showFriendPicker];
            }];
        } else {
            [self showFriendPicker];
        }
    
}

- (void) showFriendPicker {
    if (self.friendPickerController == nil) {
        // Create friend picker, and get data loaded into it.
        self.friendPickerController = [[FBFriendPickerViewController alloc] init];
        self.friendPickerController.title = @"Select Friends";
        self.friendPickerController.delegate = self;
    }
    [self.friendPickerController loadData];
    [self.friendPickerController clearSelection];
    
    // Present the friend picker
    [self presentViewController:self.friendPickerController
                       animated:YES
                     completion:^(void){
                         [self addSearchBarToFriendPickerView];
                     }
     ];
}

- (void)addSearchBarToFriendPickerView
{
    if (self.searchBar == nil) {
        CGFloat searchBarHeight = 44.0;
        self.searchBar =
        [[UISearchBar alloc]
         initWithFrame:
         CGRectMake(0,0,
                    self.view.bounds.size.width,
                    searchBarHeight)];
        self.searchBar.autoresizingMask = self.searchBar.autoresizingMask |
        UIViewAutoresizingFlexibleWidth;
        self.searchBar.delegate = self;
        self.searchBar.showsCancelButton = YES;
        
        [self.friendPickerController.canvasView addSubview:self.searchBar];
        CGRect newFrame = self.friendPickerController.view.bounds;
        newFrame.size.height -= searchBarHeight;
        newFrame.origin.y = searchBarHeight;
        self.friendPickerController.tableView.frame = newFrame;
    }
}

#pragma mark - FBFriendPickerDelegate methods
- (void)facebookViewControllerCancelWasPressed:(id)sender
{
    NSLog(@"Friend selection cancelled.");
    [self handlePickerDone];
}

- (void)facebookViewControllerDoneWasPressed:(id)sender
{
    for (id<FBGraphUser> user in self.friendPickerController.selection) {
        NSLog(@"Friend selected: %@", user.name);
        [self.delegate sendCurrentTaleToUser:[NSString stringWithFormat:@"%d", 20]];
    }
    [self handlePickerDone];
}

- (void) handlePickerDone
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
 * This delegate method is called to decide whether to show a user
 * in the friend picker list.
 */
- (BOOL)friendPickerViewController:(FBFriendPickerViewController *)friendPicker
                 shouldIncludeUser:(id<FBGraphUser>)user
{
    // If there is a search query, filter the friend list based on this.
    if (self.searchText && ![self.searchText isEqualToString:@""]) {
        NSRange result = [user.name
                          rangeOfString:self.searchText
                          options:NSCaseInsensitiveSearch];
        if (result.location != NSNotFound) {
            // If friend name matches partially, show the friend
            return YES;
        } else {
            // If no match, do not show the friend
            return NO;
        }
    } else {
        // If there is no search query, show all friends.
        return YES;
    }
    return YES;
}

#pragma mark - UISearchBarDelegate methods
- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar
{
    // Trigger the search
    [self handleSearch:searchBar];
}

- (void) handleSearch:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    self.searchText = searchBar.text;
    [self.friendPickerController updateView];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    // Clear the search query and dismiss the keyboard
    self.searchText = nil;
    [searchBar resignFirstResponder];
}


@end
