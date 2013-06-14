//
//  MTUserModel.h
//  MusTale
//
//  Created by Zenan on 30/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

/*
 {
 user: [2]
 0:  {
 uid: "1"
 fb_id: "1234"
 email: "test@gmail.com"
 name: "testuser"
 gender: "0"
 profile_url: "https://graph.facebook.com/1278726394/picture"
 fb_location_id: ""
 link: ""
 created_at: "2013-06-01 19:18:07"
 }-
 1:  {
 uid: "14"
 fb_id: "111"
 email: "test1"
 name: "jjp11"
 gender: "1"
 profile_url: "testprofile"
 fb_location_id: "test1"
 link: "12345"
 created_at: "2013-06-07 00:30:58"
 }-
 -
 }
 */

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>  
@interface MTUserModel:NSObject
@property (nonatomic,strong) NSString* ID;
@property (nonatomic,strong) NSString* fbID;
@property (nonatomic,strong) NSString* email;
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* gender;
@property (nonatomic,strong) NSString* profileURL;
@property (nonatomic,strong) NSString* fbLocationID;
@property (nonatomic,strong) NSString* link;
@end
