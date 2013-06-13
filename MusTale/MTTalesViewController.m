//
//  MTTalesViewController.m
//  MusTale
//
//  Created by Zenan on 30/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTTalesViewController.h"
#import "MTTextTaleView.h"
#import "UIViewController+SliderView.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.taleScrollView.pagingEnabled = YES;
    self.taleScrollView.showsHorizontalScrollIndicator = NO;
    
    [self setStyling];
    //[self removeGestures];
    
    self.taleScrollView.contentSize = CGSizeMake(10 * self.taleScrollView.frame.size.width, self.taleScrollView.frame.size.height);
    for (int i = 0; i < 10; i++) {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"MTTextNoteView" owner:self options:nil];
        MTTextTaleView *taleView = [views objectAtIndex:0];
        CGRect frame = self.taleScrollView.frame;
        frame.origin.y = 0;
        frame.origin.x = i * frame.size.width;
        NSLog(@"frame for view %d: %@", i, NSStringFromCGRect(frame));
        taleView.frame = frame;
        [taleView setText:@"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum!"];
        [taleView setStyling];
        [self.taleScrollView addSubview:taleView];
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
}


- (void) goBack
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void) confirm
{
    
}
@end
