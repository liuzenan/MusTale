//
//  MTDedicationViewController.m
//  MusTale
//
//  Created by Zenan on 27/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTDedicationViewController.h"
#import "NSDate+TimeAgo.h"

@interface MTDedicationViewController ()

@end

@implementation MTDedicationViewController

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setUpContent];
    [self setStyling];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setProfilePic:nil];
    [self setUserName:nil];
    [self setDate:nil];
    [self setTextTale:nil];
    [self setCommentsCount:nil];
    [self setBottomSeparator:nil];
    [self setScrollView:nil];
    [self setBackBtn:nil];
    [super viewDidUnload];
}
- (IBAction)togglePlay:(id)sender {
}


- (void) setCurrentTale:(MTDedicationModel *)dedication
{
    self.currentDedication = dedication;
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setUpContent
{
    [self.userName setText:self.currentDedication.from.name];
    [self.commentsCount setText:[NSString stringWithFormat:@"%d comments", self.currentDedication.tale.commentCount]];
    [self setText:self.currentDedication.tale.text];
    [self.date setText:[self.currentDedication.createdAt timeAgo]];
    [self.profilePic setImageWithURL:[NSURL URLWithString:self.currentDedication.from.profileURL]];
}

- (void)setText:(NSString*)text
{
    NSMutableAttributedString *str = [NSMutableAttributedString attributedStringWithString:text];
    [str setFont:[UIFont fontWithName:LATO_REGULAR size:14.0f]];
    
    OHParagraphStyle* paragraphStyle = [OHParagraphStyle defaultParagraphStyle];
    paragraphStyle.lineSpacing = 5.f; // increase space between lines by 5 points
    paragraphStyle.paragraphSpacingBefore = 20.0f;
    [str setParagraphStyle:paragraphStyle];
    [str setTextAlignment:kCTTextAlignmentNatural lineBreakMode:kCTLineBreakByWordWrapping];
    
    [self.textTale setAttributedText:str];
}


- (void) setStyling
{
    [self.userName setFont:[UIFont fontWithName:LATO_BOLD size:16.0f]];
    [self.date setFont:[UIFont fontWithName:LATO_REGULAR size:12.0f]];
    
    [self.backBtn setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    
    CGRect currentFrame = self.textTale.frame;
    CGSize max = CGSizeMake(self.textTale.frame.size.width, INFINITY);
    CGSize expected = [self.textTale.attributedText sizeConstrainedToSize:max];
    currentFrame.size.height = expected.height;
    self.textTale.frame = currentFrame;
    
    CGRect dividerFrame = self.bottomSeparator.frame;
    dividerFrame.origin.y = self.textTale.frame.origin.y + self.textTale.frame.size.height + 20.0f;
    self.bottomSeparator.frame = dividerFrame;
    
    CGRect commentsFrame = self.commentsCount.frame;
    commentsFrame.origin.y = self.bottomSeparator.frame.origin.y + 16.0f;
    self.commentsCount.frame = commentsFrame;
    
    [self.commentsCount setFont:[UIFont fontWithName:LATO_REGULAR size:12.0f]];
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(self.commentsCount.frame))];
    
    NSLog(@"content size: %@", NSStringFromCGSize(self.scrollView.contentSize));
}

@end
