//
//  CHDraggableView.h
//  ChatHeads
//
//  Created by Matthias Hochgatterer on 4/19/13.
//  Copyright (c) 2013 Matthias Hochgatterer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CHDraggableViewDelegate;
@interface CHDraggableView : UIView

@property (nonatomic, assign) id<CHDraggableViewDelegate> delegate;
@property (nonatomic, strong) UIImageView *songCover;

- (void)snapViewCenterToPoint:(CGPoint)point edge:(CGRectEdge)edge;
- (id) draggableViewWithImageURL:(NSURL *)imageURL;
- (void)changeSongCover:(NSURL *)imageURL;

@end

@protocol CHDraggableViewDelegate <NSObject>

- (void)draggableViewHold:(CHDraggableView *)view;
- (void)draggableView:(CHDraggableView *)view didMoveToPoint:(CGPoint)point;
- (void)draggableViewReleased:(CHDraggableView *)view;

- (void)draggableViewTouched:(CHDraggableView *)view;

- (void)draggableViewNeedsAlignment:(CHDraggableView *)view;

@end