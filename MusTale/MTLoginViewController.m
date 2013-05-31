//
//  MTLoginViewController.m
//  MusTale
//
//  Created by Zenan on 30/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTLoginViewController.h"

@interface MTLoginViewController ()

@end

@implementation MTLoginViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (IBAction)loginBtnPressed:(id)sender {
    
    [SVProgressHUD showSuccessWithStatus:@"Successfully logged in!"];
    [self performSegueWithIdentifier:@"kLoadSliderView" sender:self];

}


#pragma mark - Facebook Login Delegates

- (void)facebookLoginFailedWithError:(NSError *)error
{
    
}

- (void)facebookLoginSuccessWithExistingUser
{
    
}

- (void)facebookLoginSuccessWithNewUser
{
    
}
@end
