//
//  MTPlaylistListViewController.m
//  MusTale
//
//  Created by Zenan on 30/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTPlaylistListViewController.h"
#import "MTSliderViewController.h"
#import "UIViewController+SliderView.h"
#import "MTPlaylistListCell.h"
#import "UIViewController+DoubleRightBarItems.h"
#import "UIColor+i7HexColor.h"
#import <QuartzCore/QuartzCore.h>
#import "MTFloatMusicViewController.h"
#import "MTSongModel.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "MTPlayMusicViewController.h"
#import "MTNetworkController.h"


#define PLAY_LIST_CELL_HEIGHT 124.0f

@interface MTPlaylistListViewController ()

@end

@implementation MTPlaylistListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    MTSliderViewController *sliderController = (MTSliderViewController*)self.slidingViewController;
    self.delegate = sliderController;
    self.tableView.contentOffset = CGPointMake(0.0f, 44.0f);
    [self setupTopViewController];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupRightNavBarItems];
    [self setStyling];
    
    self.playlist = [NSMutableArray array];
    
    MTSliderViewController *sliderController = (MTSliderViewController*)self.slidingViewController;
    self.delegate = sliderController;
    
    
    // set up search bar
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"MTSearchBar" owner:self options:nil];
    self.searchController = (MTSearchBarController*)[objects objectAtIndex:1];
    self.searchController.delegate = self;
    self.searchController.searchBarDelegate = self;

    self.tableView.tableHeaderView = self.searchController.searchBar;
    
}

- (void)loadPopular
{
    
}

- (void)loadFeatured
{
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.playlist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlaylistListCell";
    MTPlaylistListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[MTPlaylistListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PlaylistListCell"];
    }
    
    [cell setStyling];
    
    [cell.contentWrapper.layer setCornerRadius:4.0f];
    // border
    [cell.contentWrapper.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [cell.contentWrapper.layer setBorderWidth:0.4f];
    
    cell.contentWrapper.layer.shouldRasterize = YES;
    cell.contentWrapper.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    // Configure the cell...
    
    MTSongModel *song = [self.playlist objectAtIndex:indexPath.row];
    [cell.songTitle setText:song.trackName];
    [cell.songCoverImage setImageWithURL:song.artworkUrl100];
    [cell.singerName setText:song.artistName];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return PLAY_LIST_CELL_HEIGHT;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MTPlayMusicViewController *play = [self.storyboard instantiateViewControllerWithIdentifier:@"Playlist"];
    [self.navigationController pushViewController:play animated:YES];
    [play loadPlaylist:self.playlist];
    
    [play playSongWithIndex:indexPath.row];
}

- (IBAction)showGridView:(id)sender {
    NSLog(@"show grid view");
    [self.delegate changedTopViewControllerToGrid];
}

- (void)viewDidUnload {
    [self setGridButton:nil];
    [super viewDidUnload];
}


- (void)setStyling{
    
    [self.gridButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#fefef8"];
    self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 10.0f, 0.0f);
    
}

- (void)showSearchBar
{
    NSLog(@"show animation");
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    self.tableView.contentOffset = CGPointMake(0.0f, 0.0f);
    
    [UIView commitAnimations];

}

- (void)showMenu
{
    [self.slidingViewController anchorTopViewTo:ECLeft];
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    NSLog(@"begin search");
    [self.playlist removeAllObjects];
    [self.tableView reloadData];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    NSLog(@"load results table view");
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    NSLog(@"end search");
}

-(void)didLoadSearchResult:(NSArray *)result
{
    self.playlist = [NSMutableArray arrayWithArray:result];
    [self.tableView reloadData];
}

@end
