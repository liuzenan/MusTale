//
//  MTSongViewController.m
//  MusTale
//
//  Created by Zenan on 5/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTSongViewController.h"
#import "MTPlaybackController.h"

@interface MTSongViewController (){
    BOOL isMainControlBtnHide;
    BOOL isOpenAnimationFinished;
}

@property (nonatomic,strong) NSTimer * timer;
@end

CGFloat const UPDATE_INTERVAL = 0.01;

@implementation MTSongViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithViewAndModel:(MTSongView*) v Model:(MTSongModel*)m {
    if (self = [super init]) {
        self.songview = v;
        self.songmodel = m;
        isCircleControlOn = NO;
        self.controlButtons = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeCircleWithNoAnimation) name:MTSongScrollNotification object:nil];
    }
    return self;
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification
{
    NSLog(@"music stopped notification");
    
    [self stop];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    isMainControlBtnHide = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addGestureRecognizersToView:self.songview.leftControl Selector:@selector(singleTap:)];
    [self addGestureRecognizersToView:self.songview.rightControl Selector:@selector(toggleCircleControl:)];
    [self addAllControlButtons];
    if (isMainControlBtnHide) {
        [self.songview.leftControl setAlpha:1.0f];
        [self.songview.rightControl setAlpha:1.0f];
        isMainControlBtnHide = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self stopRotate];
    [super viewWillDisappear:animated];
}

- (void)viewWillUnload
{
    [self stopRotate];
    [self removeAllControlButtons];
    [super viewWillUnload];
}

- (void) addAllControlButtons
{
    
    if ([self.controlButtons count] == 0) {
        
        for (int i = 0; i < NUM_OF_CONTROLS; i++) {
            UIView *button = [self createControlButton:i];
            [self.controlButtons addObject:button];
            [self.songview.superview insertSubview:button belowSubview:self.songview];
            [self addGestureRecognizersToControl:button Type:i];
        }
        
    }
}

- (void) removeAllControlButtons
{
    @try {
        for (int i = 0; i < NUM_OF_CONTROLS; i++) {
            UIView *button = [self.controlButtons objectAtIndex:i];
            [button removeFromSuperview];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"cannot remove button or there's no control buttons");
    }
    @finally {
        [self.controlButtons removeAllObjects];
    }
    
}

- (void)loadView {
    [super loadView];
    self.view = self.songview;
}

+ (MTSongViewController*) songViewControllerWithViewAndModel:(MTSongView*)songview Model:(MTSongModel*)songmodel {
    return [[MTSongViewController alloc] initWithViewAndModel:songview Model:songmodel];
}

- (void)addGestureRecognizersToView:(UIView *)the_view Selector:(SEL)selector
{
    
    the_view.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
    [tapGesture setDelegate:self];
    [tapGesture setNumberOfTapsRequired:1]; // double tap
    [the_view addGestureRecognizer:tapGesture];
    
}

- (void)addGestureRecognizersToControl:(UIView*)control Type:(ControlButtonType)type
{
    control.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture;
    switch (type) {
        case kButtonLike:
        {
            tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeSong:)];
            break;
        }
        case kButtonRecord:
        {
            tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recordVoice:)];
            break;
        }
        case kButtonTale:
        {
            tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTales:)];
            break;
        }
        case kButtonTweets:
        {
            tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTweets:)];
            break;
        }
        case kButtonWrite:
        {
            tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(writeMessage:)];
            break;
        }
        default:
            break;
    }
    
    if (tapGesture) {
        [tapGesture setDelegate:self];
        [tapGesture setNumberOfTapsRequired:1]; // double tap
        [control addGestureRecognizer:tapGesture];
    }
}


// rotating
- (void) startRotate {
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:UPDATE_INTERVAL target:self selector:@selector(update) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void) stopRotate {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void) update{
    [self rotateView];
    [self changeProgress];
}


// set progress 
- (void)changeProgress
{
    MPMoviePlayerController *player = [[MTPlaybackController sharedInstance] player];
    NSTimeInterval current = player.currentPlaybackTime;
    CGFloat percent = (double) current / (double) player.duration;
    
    if (percent >= 0.0f && percent <= 1.0f) {
        self.songview.progress.percent = percent * 100;
        [self.songview.progress setNeedsDisplay];
        
        if (percent == 1.0f) {
            [self stop];
        }
    }
}


- (void) setProgressPercent:(CGFloat)p_percent{
    if (p_percent >= 0.0f && p_percent <= 100.0f) {
        self.songview.progress.percent = p_percent;
        [self.songview.progress setNeedsDisplay];
    }
}


- (void) rotateView {
    self.songview.transform = CGAffineTransformRotate(self.songview.transform, M_PI / 200.0f);
}

- (void) showTweets:(UIGestureRecognizer *)gesture{
    [self.delegate showTweets:self.songmodel];
}

- (void) showTales:(UIGestureRecognizer *)gesture{
    [self.delegate showTales:self.songmodel];
}

- (void) recordVoice:(UIGestureRecognizer *)gesture{
    
    if (isOpenAnimationFinished) {
        [self stopRotate];
        
        
        [UIView animateWithDuration:0.2f animations:^{
            [self closeCircleWithNoAnimation];
            [self.songview.leftControl setAlpha:0.0f];
            [self.songview.rightControl setAlpha:0.0f];
            [self.songview setTransform:CGAffineTransformMakeRotation(0.0f)];
        } completion:^(BOOL finished) {
            isMainControlBtnHide = YES;
            [self.delegate recordVoice:self.songmodel];
        }];
    }
    
}

- (void) writeMessage:(UIGestureRecognizer *)gesture{
    [self.delegate writeMessage:self.songmodel];
}

- (void) likeSong:(UIGestureRecognizer *)gesture{
    [self.delegate likeSong:self.songmodel];
}

- (void) toggleCircleControl:(UIGestureRecognizer *)gesture{
    if (isCircleControlOn) {
        [self closeCircle];
    } else {
        [self openCircle];
    }
}

- (void) singleTap:(UIGestureRecognizer *)gesture {
    if (self.timer) {
        NSLog(@"tap pause");
        [self pause];
    } else {
        NSLog(@"tap play");
        [self play];
    }
}


#pragma mark - control circle open and close animations

- (void) openCircle {
    [self.songview addControlButtonImage:kControlStateOn Animated:YES];
    isCircleControlOn = YES;
    
    for (int i = 0; i < 5; i++) {
        [self otherControlOpenAnimation:i];
    }
    
    [self leftControlOpenAnimation];
    [self rightControlOpenAnimation];
}

- (void) otherControlOpenAnimation:(ControlButtonType)i
{
    UIView *button = [self.controlButtons objectAtIndex:i];
    CGPoint endPos = [self getButtonEndPosition:i];
    CGPoint currentCenter = button.center;
    
    SKBounceAnimation *animation = [SKBounceAnimation animationWithKeyPath:@"position"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue = [NSValue valueWithCGPoint:currentCenter];
    animation.toValue = [NSValue valueWithCGPoint:endPos];
    animation.duration = DEFAULT_CAANIMATION_DURATION;
    animation.delegate = self;
    button.layer.position = endPos;
    [button.layer addAnimation:animation forKey:ANIMATION_OPEN_CONTROL_KEY];
    isOpenAnimationFinished = NO;
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    isOpenAnimationFinished = YES;
}

- (void) otherControlCloseAnimation:(ControlButtonType)i
{
    UIView *button = [self.controlButtons objectAtIndex:i];
    CGPoint endPos = self.songview.center;
    CGPoint currentCenter = button.center;
    
    SKBounceAnimation *animation = [SKBounceAnimation animationWithKeyPath:@"position"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue = [NSValue valueWithCGPoint:currentCenter];
    animation.toValue = [NSValue valueWithCGPoint:endPos];
    animation.duration = DEFAULT_CAANIMATION_DURATION;
    button.layer.position = endPos;
    [button.layer addAnimation:animation forKey:nil];
}

- (void) leftControlOpenAnimation {
    UIView *button = self.songview.leftControl;
    CGPoint endPos = CGPointMake(self.songview.center.x,
                                 self.songview.center.y + self.songview.radius + OUTER_CIRCLE_WIDTH);
    CGPoint currentCenter = button.center;
    
    SKBounceAnimation *animation = [SKBounceAnimation animationWithKeyPath:@"position"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue = [NSValue valueWithCGPoint:currentCenter];
    animation.toValue = [NSValue valueWithCGPoint:endPos];
    animation.duration = DEFAULT_CAANIMATION_DURATION;
    button.layer.position = endPos;
    [button.layer addAnimation:animation forKey:nil];
}

- (void) rightControlOpenAnimation {
    UIView *button = self.songview.rightControl;
    CGPoint endPos = self.songview.center;
    CGPoint currentCenter = button.center;
    
    SKBounceAnimation *animation = [SKBounceAnimation animationWithKeyPath:@"position"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue = [NSValue valueWithCGPoint:currentCenter];
    animation.toValue = [NSValue valueWithCGPoint:endPos];
    animation.duration = DEFAULT_CAANIMATION_DURATION;
    button.layer.position = endPos;
    [button.layer addAnimation:animation forKey:nil];
}

- (void) leftControlCloseAnimation {
    UIView *button = self.songview.leftControl;
    CGPoint endPos = CGPointMake(self.songview.center.x - self.songview.radius * 0.5f,
                                 self.songview.center.y + self.songview.radius);
    CGPoint currentCenter = button.center;
    
    SKBounceAnimation *animation = [SKBounceAnimation animationWithKeyPath:@"position"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue = [NSValue valueWithCGPoint:currentCenter];
    animation.toValue = [NSValue valueWithCGPoint:endPos];
    animation.duration = DEFAULT_CAANIMATION_DURATION;
    button.layer.position = endPos;
    [button.layer addAnimation:animation forKey:nil];
}

- (void) rightControlCloseAnimation {
    UIView *button = self.songview.rightControl;
    CGPoint endPos = CGPointMake(self.songview.center.x + self.songview.radius * 0.5f,
                                 self.songview.center.y + self.songview.radius);
    CGPoint currentCenter = button.center;
    
    SKBounceAnimation *animation = [SKBounceAnimation animationWithKeyPath:@"position"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue = [NSValue valueWithCGPoint:currentCenter];
    animation.toValue = [NSValue valueWithCGPoint:endPos];
    animation.duration = DEFAULT_CAANIMATION_DURATION;
    button.layer.position = endPos;
    [button.layer addAnimation:animation forKey:nil];
}

- (void) closeCircleWithNoAnimation
{
    if (isCircleControlOn) {
        for (int i = 0; i < NUM_OF_CONTROLS; i++) {
            UIView *button = [self.controlButtons objectAtIndex:i];
            [button setCenter:self.songview.center];
        }
        [self.songview addControlButtonImage:kControlStateOff Animated:NO];
        [self.songview.leftControl setCenter:CGPointMake(self.songview.center.x - self.songview.radius * 0.5f,
                                                         self.songview.center.y + self.songview.radius)];
        [self.songview.rightControl setCenter:CGPointMake(self.songview.center.x + self.songview.radius * 0.5f,
                                                          self.songview.center.y + self.songview.radius)];
        isCircleControlOn = NO;
    }
}

- (void) closeCircle{
    [self.songview addControlButtonImage:kControlStateOff Animated:YES];
    isCircleControlOn = NO;
    [self leftControlCloseAnimation];
    [self rightControlCloseAnimation];
    for (int i = 0; i < 5; i++) {
        [self otherControlCloseAnimation:i];
    }
}

- (CGPoint) getButtonEndPosition:(ControlButtonType)type
{
    return CGPointMake(self.songview.center.x + (self.songview.radius + OUTER_CIRCLE_WIDTH) * cos(type * M_PI / 3.0f + M_PI / 1.2f),
                       self.songview.center.y + (self.songview.radius + OUTER_CIRCLE_WIDTH) * sin(type * M_PI / 3.0f + M_PI / 1.2f));
}

- (UIView*) createControlButton:(ControlButtonType)type
{
    UIView *button = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CONTROL_BUTTON_RADIUS*2, CONTROL_BUTTON_RADIUS*2)];
    button.layer.cornerRadius = CONTROL_BUTTON_RADIUS;
    button.backgroundColor = [UIColor whiteColor];
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.borderWidth = 1;
    button.alpha = 1.0f;
    button.center = self.songview.center;
    
    button.layer.shouldRasterize = YES;
    button.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    UIImageView *image;
    switch (type) {
        case kButtonTweets:
        {
            image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:ICON_TWEETS]];
            break;
        }
        case kButtonRecord:
        {
            image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:ICON_RECORD]];
            break;
        }
        case kButtonWrite:
        {
            image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:ICON_WRITE]];
            break;
        }
        case kButtonTale:
        {
            image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:ICON_TALE]];
            break;
        }
        case kButtonLike:
        {
            image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:ICON_LIKE]];
            break;
        }
        default:
            break;
    }
    
    if (image) {
        image.center = CGPointMake(CGRectGetMidX(button.bounds), CGRectGetMidY(button.bounds));
        [button addSubview:image];
    }
    
    return button;
}

- (void) pause {
    
    [self.songview removeStateImage];
    [self.songview addStateImage:kStateInit];
    [[MTPlaybackController sharedInstance] pause];
    [self stopRotate];
    [self.delegate didPausedPlaying:self];
}

- (void) stop {
    
    [self.songview removeStateImage];
    [self.songview addStateImage:kStateInit];
    [self setProgressPercent:0];
    [[MTPlaybackController sharedInstance] stop];
    [self stopRotate];
    self.songview.transform = CGAffineTransformMakeRotation(0.0);
    [self.delegate didFinishedPlaying:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:[[MTPlaybackController sharedInstance] player]];
}

- (void)play
{

    if (![[[MTPlaybackController sharedInstance] currentSong] isEqual:self.songmodel]) {
        [[MTPlaybackController sharedInstance] stop];
        [[MTPlaybackController sharedInstance] setCurrentSong:self.songmodel];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayBackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:[[MTPlaybackController sharedInstance] player]];
    }

    [self.songview removeStateImage];
    [self.songview addStateImage:kStatePause];
    [self startRotate];
    [[MTPlaybackController sharedInstance] play];
    [self.delegate didStartedPlaying:self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
