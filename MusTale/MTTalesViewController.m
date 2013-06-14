//
//  MTTalesViewController.m
//  MusTale
//
//  Created by Zenan on 30/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTTalesViewController.h"
#import "MTTextTaleView.h"
#import "MTVoiceTaleView.h"
#import "UIViewController+SliderView.h"
#import "UIColor+i7HexColor.h"
#import <QuartzCore/QuartzCore.h>

@interface MTTalesViewController ()

@end

@implementation MTTalesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillShow:)
     name:UIKeyboardWillShowNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillHide:)
     name:UIKeyboardWillHideNotification
     object:nil];
}

- (void)moveTextViewForKeyboard:(NSNotification*)aNotification up:(BOOL)up {
    NSDictionary* userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect newFrame = self.view.frame;
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    newFrame.size.height -= keyboardFrame.size.height * (up?1:-1);
    self.view.frame = newFrame;
    
    [UIView commitAnimations];
}

- (void)keyboardWillShow:(NSNotification*)aNotification
{
    self.taleScrollView.scrollEnabled = NO;
    [self moveTextViewForKeyboard:aNotification up:YES];
}

- (void)keyboardWillHide:(NSNotification*)aNotification
{
    self.taleScrollView.scrollEnabled = YES;
    [self moveTextViewForKeyboard:aNotification up:NO];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

-(void)finishEdit
{
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.taleScrollView.pagingEnabled = YES;
    self.taleScrollView.showsHorizontalScrollIndicator = NO;
    
    [self setStyling];
    //[self removeGestures];
    
    self.taleScrollView.contentSize = CGSizeMake(10 * self.taleScrollView.frame.size.width, self.taleScrollView.frame.size.height);
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(finishEdit)];
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(finishEdit)];
    tapGes.numberOfTapsRequired = 1;
    tapGes.delegate = self;
    panGes.delegate = self;
    [self.taleScrollView addGestureRecognizer:tapGes];
    [self.taleScrollView addGestureRecognizer:panGes];
    
    for (int i = 0; i < 10; i++) {
        
        if ((i % 2) == 0) {
            NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"MTVoiceTaleView" owner:self options:nil];
            MTVoiceTaleView *taleView = [views objectAtIndex:0];
            CGRect frame = self.taleScrollView.frame;
            frame.origin.y = 0;
            frame.origin.x = i * frame.size.width;
            NSLog(@"frame for view %d: %@", i, NSStringFromCGRect(frame));
            taleView.frame = frame;
            
            [taleView setStyling];
            [self.taleScrollView addSubview:taleView];
        } else {
            NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"MTTextTaleView" owner:self options:nil];
            MTTextTaleView *taleView = [views objectAtIndex:0];
            
            CGRect frame = self.taleScrollView.frame;
            frame.origin.y = 0;
            frame.origin.x = i * frame.size.width;
            NSLog(@"frame for view %d: %@", i, NSStringFromCGRect(frame));
            taleView.frame = frame;
            
            [taleView setText:@"Edison was the master of combination and rearrangement. One of his signature technological revolutions, the phonograph, entailed little more than taking previous inventions and combining them.\nThe telegraph repeater was an invention that Edison patented to record, store and later play back telegraphic messages. The phonautograph was an invention by Leon Scott that recorded the vibration of a diaphragm moving to waves of sound. Scott’s invention used a sheet of paper coated with lampblack and fixed to a rotating cylinder to record sound’s visual pattern. Edison’s phonograph joined the two: the recording on a rotating cylinder and the storage and later playback of messages. A stylus attached to a diaphragm recorded auditory vibrations onto the phonograph’s rotating cylinder, which was covered with a sheet of tin foil. A second diaphragm played sound back just as it was originally recorded. It was the phonoautograph version of the telegraph repeater—a technological sensation."];
            [taleView setStyling];
            [self.taleScrollView addSubview:taleView];
        }
        

    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTaleScrollView:nil];
    [self setBackbtn:nil];
    [self setMenuBtn:nil];
    [self setCommentBar:nil];
    [self setCommentField:nil];
    [super viewDidUnload];
}

- (void) setStyling {
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setImage:[UIImage imageNamed:DEFAULT_ICON_BACK] forState:UIControlStateNormal];
    [back sizeToFit];
    CGRect backFrame = back.frame;
    NSLog(@"menu frame: %@", NSStringFromCGRect(backFrame));
    backFrame.size.width += 20.0f;
    back.frame = backFrame;
    [back setShowsTouchWhenHighlighted:YES];
    [back addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirm setImage:[UIImage imageNamed:DEFAULT_ICON_CONFIRM] forState:UIControlStateNormal];
    [confirm sizeToFit];
    CGRect confirmFrame = confirm.frame;
    NSLog(@"menu frame: %@", NSStringFromCGRect(confirmFrame));
    confirmFrame.size.width += 20.0f;
    confirm.frame = confirmFrame;
    [confirm setShowsTouchWhenHighlighted:YES];
    [confirm addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    
    [self.backbtn setCustomView:back];
    [self.menuBtn setCustomView:confirm];
    
    [self.menuBtn setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.backbtn setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [self.commentBar setBackgroundImage:[UIImage imageNamed:@"navbar-gray"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    
    [self.commentField setBackgroundColor:[UIColor whiteColor]];
    [self.commentField setBorderStyle:UITextBorderStyleNone];
    self.commentField.layer.cornerRadius = 4.0f;
    self.commentField.layer.masksToBounds = YES;
    self.commentField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.commentField.layer.borderWidth = 0.5f;
    self.commentField.returnKeyType = UIReturnKeySend;
    [self.commentField setFont:[UIFont fontWithName:LATO_REGULAR size:14.0f]];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.commentField.leftView = paddingView;
    self.commentField.leftViewMode = UITextFieldViewModeAlways;
    if ([self.commentBar respondsToSelector:@selector(shadowImage)]){
        [self.commentBar setShadowImage:[[UIImage alloc] init] forToolbarPosition:UIToolbarPositionBottom];
    }
    
}


- (void) goBack
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void) confirm
{
    
}
@end
