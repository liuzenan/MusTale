//
//  CacheManager.h
//  StreetGaGaApp
//
//  Created by Jiao Jing Ping on 21/6/13.
//  Copyright (c) 2013 StreetGaGa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTUserModel.h"
@interface MTCacheManager : NSObject
+ (instancetype)sharedManager;

#pragma mark user_credential
@property (nonatomic,strong) NSString* cachedCurUserAccessToken;
@property (nonatomic,strong) MTUserModel* cachedCurUser;
- (void) clearCachedUser;
- (void) clearCachedAccessToken;
- (void) clearUserData;


- (void) cacheObjectForKey:(NSString*)key object:(id<NSCoding>)object;
- (id<NSCoding>) objectForKey:(NSString*)key;
- (BOOL) isCached:(NSString*)key;
- (void) clearObjectData;
@end
