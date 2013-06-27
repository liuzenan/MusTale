//
//  MTWriteTaleViewController.m
//  MusTale
//
//  Created by Zenan on 10/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTWriteTaleViewController.h"
#import "UIColor+i7HexColor.h"
#import "ViewController+Snapshot.h"
#import "MTTaleModel.h"
#import "MTNetworkController.h"
#import "MTDedicationModel.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface MTWriteTaleViewController ()

@end

@implementation MTWriteTaleViewController

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
    self.sendTale = [self.storyboard instantiateViewControllerWithIdentifier:@"SendTaleView"];
    self.sendTale.delegate = self;
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
    
    CGRect newFrame = self.taleTextView.frame;
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    newFrame.size.height -= keyboardFrame.size.height * (up?1:-1);
    self.taleTextView.frame = newFrame;
    
    [UIView commitAnimations];
}

- (void)keyboardWillShow:(NSNotification*)aNotification
{
    self.confirmBtn.enabled = true;
    [self moveTextViewForKeyboard:aNotification up:YES];
}

- (void)keyboardWillHide:(NSNotification*)aNotification
{
    self.confirmBtn.enabled = false;
    [self moveTextViewForKeyboard:aNotification up:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBack{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)confirm{
    [self.view endEditing:YES];
    UIImage *snapshot = [self makeImage];
    
    [self.sendTale setBgImg:snapshot];
    [self presentModalViewController:self.sendTale animated:NO];
}

- (void)sendCurrentTale
{
    MTTaleModel* tale = [MTTaleModel new];
    tale.isAnonymous = NO;
    tale.isPublic = YES;
    tale.text = self.taleTextView.text;
    tale.isFront = NO;
    
    [SVProgressHUD showWithStatus:@"Posting your tale..." maskType:SVProgressHUDMaskTypeBlack];
    [[MTNetworkController sharedInstance] postSong:self.currentSong completeHandler:^(id data, NSError *error) {
        [[MTNetworkController sharedInstance] postTale:tale to:data completeHandler:^(id data, NSError *error) {
            if (!error) {
                NSLog(@"posted tale to server: %@", data);
                [SVProgressHUD showSuccessWithStatus:@"Tale posted!"];
                [self.sendTale dismiss];
                [self goBack];
            } else {
                NSLog(@"error: %@", error);
                [SVProgressHUD showErrorWithStatus:@"Something is wrong..."];
                
            }
        }];
    }];
}

- (void)sendCurrentTaleToUser:(NSString*)userID
{
    MTTaleModel* tale = [MTTaleModel new];
    tale.isAnonymous = NO;
    tale.isPublic = YES;
    tale.text = self.taleTextView.text;
    tale.isFront = NO;
    
    MTDedicationModel *de = [MTDedicationModel new];
    de.tale = tale;
    
    [[MTNetworkController sharedInstance] postDedication:de toUser:userID completeHandler:^(id data, NSError *error) {
        if (!error) {
            NSLog(@"posted dedication to user: %@", data);
        } else {
            NSLog(@"error: %@", error);
        }
    }];
}

- (void)setStyling
{
    
    [self.view setOpaque:YES];
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
    
    [self.cancelBtn setCustomView:back];
    [self.confirmBtn setCustomView:confirm];
    
    [self.confirmBtn setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.cancelBtn setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [self.taleTextView setFont:[UIFont fontWithName:LATO_REGULAR size:16.0f]];
    [self.taleTextView setPlaceholder:@"Write your own story..."];
    
    [self.taleTextView setOpaque:YES];
    [self.taleTextView setBackgroundColor:[UIColor whiteColor]];
    
}


- (void)viewDidUnload {
    [self setCancelBtn:nil];
    [self setConfirmBtn:nil];
    [self setTaleTextView:nil];
    [super viewDidUnload];
}
@end
