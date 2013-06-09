//
//  MTRecordView.h
//  MusTale
//
//  Created by Zenan on 9/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MTRecordViewDelegate

- (void) touchDidEnd;

@end

@interface MTRecordView : UIView

@property (nonatomic, weak) id<MTRecordViewDelegate> delegate;

@end
