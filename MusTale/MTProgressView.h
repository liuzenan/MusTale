//
//  MTProgressView.h
//  MusTale
//
//  Created by Zenan on 5/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CoreAnimation.h>

@interface MTProgressView : UIView

@property (nonatomic) CGFloat percent;
@property (nonatomic) CGFloat radius;
+ (MTProgressView*) progressViewWithRadius:(CGFloat)radius ;

@end
