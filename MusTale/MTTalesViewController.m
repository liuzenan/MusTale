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
    
    //[self removeGestures];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
@end
