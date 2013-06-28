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
#import "MTRecordVoiceNoteViewController.h"
#import "MTTalesViewController.h"
#import "MTWriteTaleViewController.h"
#import "MTPlaybackController.h"
#import "MTFloatMusicViewController.h"
#import "MTTalesViewController.h"
#import "MTPlaylistController.h"
#import "MTItuneNetworkController.h"
#import "MTNetworkController.h"

// Assume the part of next|last album expose p to the current system
// Then 2 * p * radius + 2 * radius + 2 * speration = UIScreen mainscreen].bounds.width


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
    self.CDScroll.delegate = self;

    [self removeGestures];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playNextSong) name:MTPlayNextSongNotification object:nil];
}

- (void)loadPlaylist:(NSArray*)playlist
{

    self.songList = playlist;
    [[MTPlaylistController sharedInstance] setSongs:playlist];
    [self loadSongCDViews];
}

- (void)playSongWithIndex:(NSInteger)index
{
    if ([self.songList count] > 0 && index >= 0 && index < [self.songList count]) {
        [self setTitleAndName:index];
        [self activateSongViewAtIndex:index];
    }
}

- (void)addSubControllerAndView:(UIViewController *)subcontroller ToView:(UIView*) view{
    [self addChildViewController:subcontroller];
    [view addSubview:subcontroller.view];
    [subcontroller didMoveToParentViewController:self];
}

- (int) getCurrentControllerIndex {
    return (int)self.CDScroll.contentOffset.x / self.CDScroll.frame.size.width;
}

- (void) activateSongViewAtIndex:(NSInteger)index
{
    MTSongViewController *songView = [self.childViewControllers objectAtIndex:index];
    [songView play];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static NSInteger previousPage = 0;
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lroundf(fractionalPage);
    if (previousPage != page && page < [self.songList count] && page >= 0) {
        // Page has changed
        [self setTitleAndName:page];
        previousPage = page;
        [[NSNotificationCenter defaultCenter] postNotificationName:MTSongScrollNotification object:self];
    }
}

-(void)setTitleAndName:(NSInteger)page
{
    MTSongModel *model = (MTSongModel*)[self.songList objectAtIndex:page];
    [self.songTitle setText:model.trackName];
    [self.singerName setText:model.artistName];
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
                                     self.CDScroll.frame.size.height);
    
    [self.CDScroll setContentSize:CGSizeMake(width * [self.songList count] ,self.CDScroll.frame.size.height - DEFAULT_SONG_VIEW_RADIUS)];
    
    for (int i = 0; i < [self.songList count]; i++) {
        [self loadSongAtIndex:i];
    }

}



- (void) loadSongAtIndex:(NSInteger)index {
    MTSongModel * model = (MTSongModel*)[self.songList objectAtIndex:index];

    MTSongView* view = [[MTSongView alloc] initWithURLAndRadius:model.artworkUrl100 Radius:DEFAULT_SONG_VIEW_RADIUS];
    MTSongViewController *svc = [MTSongViewController songViewControllerWithViewAndModel:view Model:model];
    [svc setIndex:index];
    view.center = CGPointMake(self.CDScroll.bounds.size.width / 2 + index * (self.CDScroll.frame.size.width),
                              self.CDScroll.bounds.size.height / 2);
    svc.delegate = self;
    [self addSubControllerAndView:svc ToView:self.CDScroll];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupTopViewController];
    if ([[MTPlaybackController sharedInstance] isPlaying]) {
        for (MTSongViewController *controller in self.childViewControllers) {
            if ([controller.songmodel isEqual:[MTPlaybackController sharedInstance].currentSong]) {
                [controller startRotate];
            }
        }
    }
    
    [[MTFloatMusicViewController sharedInstance] removeFloatSong];
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
    [self setSongTitle:nil];
    [self setSingerName:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}


#pragma mark - set style

- (void)setStyling{
    
    [self.menuBtn setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.backBtn setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    // set background color
    self.CDScroll.backgroundColor = [UIColor colorWithHexString:MUSIC_BG_COLOR];
    self.view.backgroundColor = [UIColor colorWithHexString:MUSIC_BG_COLOR];
    
    [self setTextStyle];
    
}

- (void) setTextStyle{
    self.songTitle.fadeLength = 10.0f;
    self.singerName.fadeLength = 10.0f;
    self.songTitle.continuousMarqueeExtraBuffer = 80.0f;
    self.singerName.continuousMarqueeExtraBuffer = 80.0f;
    [self.singerName setMarqueeType:MLContinuous];
    [self.songTitle setMarqueeType:MLContinuous];
    [self.singerName setAnimationDelay:3.0];
    [self.songTitle setAnimationDelay:3.0];
    [self.songTitle setFont:[UIFont fontWithName:LATO_BLACK size:22.0f]];
    [self.songTitle setTextColor:[UIColor whiteColor]];
    [self.songTitle setTextAlignment:UITextAlignmentCenter];
    [self.singerName setTextColor:[UIColor whiteColor]];
    [self.singerName setFont:[UIFont fontWithName:LATO_REGULAR size:14.0f]];
    [self.singerName setTextAlignment:UITextAlignmentCenter];
    [self.songTitle setBackgroundColor:[UIColor clearColor]];
    [self.singerName setBackgroundColor:[UIColor clearColor]];
    
}


#pragma mark - button actions

- (IBAction)showMenu:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECLeft];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - SongPlayListDelegate methods

- (void) didStartedPlaying:(id)sender {
    MTSongViewController *song = (MTSongViewController*)sender;
    
    NSLog(@"song index: %d, play list song index:%d", song.index, [[MTPlaylistController sharedInstance] currentSongIndex]);
    if (song.index == [[MTPlaylistController sharedInstance] currentSongIndex]) {
        [song continuePlay];
    } else {
        [[MTPlaylistController sharedInstance] playSongAtIndex:song.index];
        [song play];
    }
}

- (void) didContinuePlaying:(id)sender
{
    NSLog(@"did continue playing");
}

- (void) didPausedPlaying:(id)sender {
    NSLog(@"did paused playing");
}
- (void) didFinishedPlaying:(id)sender {
    NSLog(@"did finished playing");
}

- (void) playNextSong
{
    NSLog(@"play next song");
    [[MTPlaylistController sharedInstance] playNextSong];
    [self activateSongViewAtIndex:[[MTPlaylistController sharedInstance] currentSongIndex]];

}

#pragma mark - control button delegate methods

-(void)showTweets:(MTSongModel *)song
{
    
}

-(void)recordVoice:(MTSongModel *)song
{
    if (song) {
        MTRecordVoiceNoteViewController *recording = [self.storyboard instantiateViewControllerWithIdentifier:@"RecordView"];
        recording.currentSong = song;
        [self presentModalViewController:recording animated:NO];
        NSLog(@"record voice presented");
        [[MTFloatMusicViewController sharedInstance] showFloatSong];
    }
}

-(void)showTales:(MTSongModel *)song
{
    if (song) {
        [[MTNetworkController sharedInstance] registerSongToServer:song completeHandler:^(id data, NSError *error) {
            MTSongModel *song = data;
            MTTalesViewController *tale = [self.storyboard instantiateViewControllerWithIdentifier:@"TalesView"];
            [self presentModalViewController:tale animated:YES];
            [tale loadTalesOfSong:song.ID];
            [[MTFloatMusicViewController sharedInstance] showFloatSong];
        }];
    }
}

-(void)likeSong:(MTSongModel *)song
{
    
}

-(void)writeMessage:(MTSongModel *)song
{
    if (song) {
        MTWriteTaleViewController *writeTale = [self.storyboard instantiateViewControllerWithIdentifier:@"WriteTaleView"];
        writeTale.currentSong = song;
        [self presentModalViewController:writeTale animated:YES];
        [[MTFloatMusicViewController sharedInstance] showFloatSong];
    }
}

@end
