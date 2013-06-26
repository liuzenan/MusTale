//
//  MTDedicationModel.h
//  MusTale
//
//  Created by Jiao Jing Ping on 23/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTUserModel.h"
#import "MTTaleModel.h"
@interface MTDedicationModel : NSObject

@property (nonatomic,strong) NSString* taleId;
@property (nonatomic,strong) MTTaleModel* tale;
@property (nonatomic,strong) MTUserModel* from;
@property (nonatomic,strong) MTUserModel* to;
@property (nonatomic) BOOL isPublic;
@property (nonatomic) BOOL isAnonymous;
@property (nonatomic,strong) NSDate* createdAt;
@end
