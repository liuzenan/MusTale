//
//  MTFloatMusicViewController.m
//  MusTale
//
//  Created by Zenan on 9/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTFloatMusicViewController.h"
#import "CHDraggableView.h"
#import "MTPlaylistController.h"

@interface MTFloatMusicViewController ()

@end

@implementation MTFloatMusicViewController

+ (MTFloatMusicViewController*) sharedInstance
{
    static MTFloatMusicViewController *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[MTFloatMusicViewController alloc] init];
    });
    
    return __sharedInstance;
}

- (void) showFloatSong
{
    UIScreen *screen = [UIScreen mainScreen];
    [self.draggableView setCenter:CGPointMake(CGRectGetMidX(screen.bounds), CGRectGetMidY(screen.bounds) - 60.0f)];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.draggableView];
}

- (void) removeFloatSong
{
    [self.draggableView removeFromSuperview];
}

- (void) changeSong:(MTSongModel *)song
{
    self.draggableView = [[CHDraggableView alloc] draggableViewWithImageURL:song.artworkUrl100];
    self.draggableView.tag = kFLOAT_MUSIC_TAG;
    
    self.draggingCoordinator = [[CHDraggingCoordinator alloc] initWithWindow:[[UIApplication sharedApplication] keyWindow] draggableViewBounds:self.draggableView.bounds];
    self.draggingCoordinator.snappingEdge = CHSnappingEdgeBoth;
    self.draggableView.delegate = self.draggingCoordinator;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
