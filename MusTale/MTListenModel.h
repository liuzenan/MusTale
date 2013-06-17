//
//  MTListenModel.h
//  MusTale
//
//  Created by Jiao Jing Ping on 18/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTListenModel : NSObject
@property (nonatomic,strong,readonly) NSString* songID;
@property (nonatomic,strong,readonly) NSString* userID;
@property (nonatomic,readonly) NSInteger listenCount;
@end
