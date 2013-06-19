//
//  MTCommentsModel.h
//  MusTale
//
//  Created by Zenan on 30/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTCommentsModel : NSObject
@property (nonatomic,strong) NSString* userID;
@property (nonatomic,strong) NSString* taleID;
@property (nonatomic,strong) NSString* content;
@property (nonatomic,strong) NSDate* createdAt;
@end
