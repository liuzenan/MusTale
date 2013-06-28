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
#import "MTFloatMusicViewController.h"
#import "MTSongModel.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "MTPlayMusicViewController.h"
#import "MTNetworkController.h"


#define PLAY_LIST_CELL_HEIGHT 124.0f

@interface MTPlaylistListViewController (){
    PlaylistType playlistType;
}

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
    [self loadPlaylist];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupRightNavBarItems];
    [self setStyling];
    
    self.playlist = [NSMutableArray array];

    // set up search bar
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"MTSearchBar" owner:self options:nil];
    self.searchController = (MTSearchBarController*)[objects objectAtIndex:1];
    self.searchController.delegate = self;
    self.searchController.searchBarDelegate = self;

    self.tableView.tableHeaderView = self.searchController.searchBar;
    
}

- (void) setType:(PlaylistType)type
{
    playlistType = type;
}

- (void) loadPlaylist
{
    if (playlistType == kPopular) {
        
        [self loadPopular];
        [self setTitle:@"Popular"];
    } else if (playlistType == kFeatured) {
    
        [self loadFeatured];
        [self setTitle:@"Featured"];
    }
}

- (void)loadPopular
{
    [[MTNetworkController sharedInstance] getPopularSongs:20 completeHandler:^(id data, NSError *error) {
        if (!error) {
            self.playlist = [NSMutableArray arrayWithArray:data];
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error);
        }
    }];
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
    
    // Configure the cell...
    
    MTSongModel *song = [self.playlist objectAtIndex:indexPath.row];
    [cell.songTitle setText:song.trackName];
    [cell.songCoverImage setImageWithURL:song.artworkUrl100];
    [cell.singerName setText:song.artistName];
    
    [cell setStyling];
    
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
