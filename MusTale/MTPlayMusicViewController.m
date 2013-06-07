//
//  MTPlayMusicViewController.m
//  MusTale
//
//  Created by Zenan on 30/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTPlayMusicViewController.h"
#import "UIViewController+SliderView.h"
#import "MTNetworkController.h"
#import "MTSongModel.h"
#import "MTSongView.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UIViewController+SliderView.h"
#import "MTConstants.h"
#import "UIColor+i7HexColor.h"

// Assume the part of next|last album expose p to the current system
// Then 2 * p * radius + 2 * radius + 2 * speration = UIScreen mainscreen].bounds.width
CGFloat const DEFAULT_SONG_VIEW_RADIUS = 100.0f;
CGFloat const DEFAULT_SONG_VIEW_SEPERATION = 40.0f;
CGFloat const DEFAULT_MINIMIZED_VIEW_HEIGHT = 50.0f;

@interface MTPlayMusicViewController ()

@property (nonatomic,strong) NSMutableArray* songs;
@property (nonatomic,strong) UITapGestureRecognizer* singleTap;

@end

@implementation MTPlayMusicViewController {
    
    MTSongViewController *curSongController;
    BOOL isCommentMode;
    CGPoint lastCenter;
    CGAffineTransform lastTransform;
    
}

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
    self.CDScroll.pagingEnabled = YES;
    self.CDScroll.showsHorizontalScrollIndicator = NO;
    [self removeGestures];
    [self loadSongs];
    
}

- (void)addSubControllerAndView:(UIViewController *)subcontroller ToView:(UIView*) view{
    [self addChildViewController:subcontroller];
    [view addSubview:subcontroller.view];
    [subcontroller didMoveToParentViewController:self];
}




- (int) getCurrentControllerIndex {
    return (int)self.CDScroll.contentOffset.x / self.CDScroll.frame.size.width;
}



- (void) loadSongs
{
    [MTNetworkController testLoadSongWithResult:^(NSArray *songs) {
        self.songList = songs;
        [self loadSongCDViews];
    }];
}

- (void) loadSongCDViews {
    if ([self.songList count] == 0) {
        //TODO Tell user there is no song
        return;
    }
    self.CDScroll.pagingEnabled = YES;
    self.CDScroll.clipsToBounds = NO;
    self.CDScroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    CGFloat width = DEFAULT_SONG_VIEW_RADIUS * 2 + DEFAULT_SONG_VIEW_SEPERATION;
    CGFloat delta = ([UIScreen mainScreen].bounds.size.width - width) / 2;
    self.CDScroll.frame = CGRectMake(self.view.frame.origin.x + delta,
                                     self.view.frame.origin.y,
                                     width,
                                     self.view.frame.size.height);
    
    [self.CDScroll setContentSize:CGSizeMake(width * [self.songList count] ,self.CDScroll.frame.size.height - DEFAULT_SONG_VIEW_RADIUS)];
    
    for (int i = 0; i < [self.songList count]; i++) {
        [self loadSongAtIndex:i];
    }

}

- (void) loadSongAtIndex:(CGFloat)index {
    MTSongModel * model = (MTSongModel*)[self.songList objectAtIndex:index];

    MTSongView* view = [[MTSongView alloc] initWithURLAndRadius:model.artworkUrl100 Radius:DEFAULT_SONG_VIEW_RADIUS];
    MTSongViewController *svc = [MTSongViewController songViewControllerWithViewAndModel:view Model:model];
    
    view.center = CGPointMake(self.CDScroll.bounds.size.width / 2 + index * (self.CDScroll.frame.size.width),
                              self.CDScroll.bounds.size.height / 2);
    svc.delegate = self;
    [self addSubControllerAndView:svc ToView:self.CDScroll];
}

- (void) didStartedPlaying:(id)sender {
    MTSongViewController* cur_svc = (MTSongViewController*)sender;
    for (MTSongViewController *svc in self.childViewControllers) {
        if (svc != cur_svc) {
            [svc reinit];
        }
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setupTopViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCDScroll:nil];
    [self setMenuBtn:nil];
    [self setBackBtn:nil];
    [self setGoBack:nil];
    [self setSongTitle:nil];
    [self setSingerName:nil];
    [super viewDidUnload];
}

- (void)setStyling{
    
    [self.menuBtn setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.backBtn setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.CDScroll.backgroundColor = [UIColor colorWithHexString:@"#2c3e50"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#2c3e50"];
    [self.songTitle setFont:[UIFont fontWithName:LATO_BLACK size:22.0f]];
    [self.singerName setFont:[UIFont fontWithName:LATO_REGULAR size:14.0f]];
    
}

- (IBAction)showMenu:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECLeft];
}
@end
