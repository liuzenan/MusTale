//
//  MTPlaylistGridViewController.m
//  MusTale
//
//  Created by Zenan on 30/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTPlaylistGridViewController.h"
#import "MTSliderViewController.h"
#import "UIViewController+SliderView.h"
#import "MTPlaylistGridCell.h"
#import "UIViewController+DoubleRightBarItems.h"

@interface MTPlaylistGridViewController ()

@end

@implementation MTPlaylistGridViewController

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
    [self setupRightNavBarItems];
    [self setStyling];
	// Do any additional setup after loading the view.
    [self.gridView setBackgroundColor:[UIColor whiteColor]];
    
    UIEdgeInsets inset = UIEdgeInsetsMake(10.0f, 0, 0, 0);
    self.gridView.contentInset = inset;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setupTopViewController];
    MTSliderViewController *sliderController = (MTSliderViewController*)self.slidingViewController;
    self.delegate = sliderController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)numberOfItemsInGridView:(AQGridView *)gridView
{
    return 20;
}

-(AQGridViewCell *)gridView:(AQGridView *)gridView cellForItemAtIndex:(NSUInteger)index
{
    static NSString *CellIdentifier = @"PlaylistGridCell";
    AQGridViewCell *cell = (AQGridViewCell *)[gridView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (!cell) {
        NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"MTPlaylistGridCell" owner:self options:nil];
        MTPlaylistGridCell *gridViewCellContent = [nibViews objectAtIndex:0];
        [gridViewCellContent setStyling];
        cell = [[AQGridViewCell alloc] initWithFrame:gridViewCellContent.frame reuseIdentifier:CellIdentifier];
        [cell.contentView addSubview:gridViewCellContent];
    }
    
    [cell setSelectionGlowColor:[UIColor clearColor]];
    
    return cell;
}

- (IBAction)showListView:(id)sender {
    NSLog(@"show list view");
    [self.delegate changedTopViewControllerToList];
}

- (void)setStyling{
    [self.listButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

- (void)viewDidUnload {
    [self setListButton:nil];
    [super viewDidUnload];
}
@end
