//
//  MTLoginViewController.h
//  MusTale
//
//  Created by Zenan on 30/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTUserController.h"
#import "SVProgressHUD.h"


@interface MTLoginViewController : UIViewController <FacebookLoginDelegate>

- (IBAction)loginBtnPressed:(id)sender;

@end
