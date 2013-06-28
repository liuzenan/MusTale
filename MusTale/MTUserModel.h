//
//  MTUserModel.h
//  MusTale
//
//  Created by Zenan on 30/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>  
@interface MTUserModel:NSObject <NSCoding>
@property (nonatomic,strong) NSString* ID;
@property (nonatomic,strong) NSString* fbID;
@property (nonatomic,strong) NSString* email;
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* gender;
@property (nonatomic,strong) NSString* profileURL;
@property (nonatomic,strong) NSString* fbLocationID;
@property (nonatomic,strong) NSString* link;

@end
