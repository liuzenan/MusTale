//
//  MTUserModel.m
//  MusTale
//
//  Created by Zenan on 30/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTUserModel.h"

@implementation MTUserModel

- (id) initWithCoder:(NSCoder *)aDecoder {
    NSString* ID = [aDecoder decodeObjectForKey:@"ID"];
    NSString* fbID = [aDecoder decodeObjectForKey:@"fbID"];
    NSString* email = [aDecoder decodeObjectForKey:@"email"];
    NSString* name = [aDecoder decodeObjectForKey:@"name"];
    NSString* gender = [aDecoder decodeObjectForKey:@"gender"];
    NSString* profileURL = [aDecoder decodeObjectForKey:@"profile"];
    NSString* fbLocationID = [aDecoder decodeObjectForKey:@"fblocation"];
    NSString* link = [aDecoder decodeObjectForKey:@"link"];
    MTUserModel* user = [MTUserModel new];
    user.ID = ID;
    user.fbID = fbID;
    user.email = email;
    user.name = name;
    user.gender = gender;
    user.profileURL = profileURL;
    user.fbLocationID = fbLocationID;
    user.link = link;
    return user;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.fbID forKey:@"fbID"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.name  forKey:@"name"];
    [aCoder encodeObject:self.gender forKey:@"gender"];
    [aCoder encodeObject:self.profileURL forKey:@"profile"];
    [aCoder encodeObject:self.fbLocationID forKey:@"fblocation"];
    [aCoder encodeObject:self.link forKey:@"link"];
}

@end
