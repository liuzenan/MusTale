//
//  CacheManager.m
//  StreetGaGaApp
//
//  Created by Jiao Jing Ping on 21/6/13.
//  Copyright (c) 2013 StreetGaGa. All rights reserved.
//

#import "MTCacheManager.h"
#import <EGOCache/EGOCache.h>
@interface MTCacheManager ()
@property (nonatomic,strong) EGOCache* credentialCache;
@property (nonatomic,strong) EGOCache* objectCache;
@end

@implementation MTCacheManager 
#define CURRENT_USER_CACHE_KEY @"currentUser"
#define CURRENT_USER_ACCESS_TOKEN_KEY @"authToken"
#define CACHE_DIRECTORY_CUR_USER @"usercache"
#define CACHE_DIRECTORY_CUR_OBJECT @"objcache"
#define DefaultUserCredentialTimeoutInterval 86400
#define DefaultObjectTimeoutInterval 86400

+ (instancetype)sharedManager {
	static id instance;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[[self class] alloc] init];
	});
	return instance;
}


- (id) init {
    if(self = [super init]) {
        self.credentialCache = [[EGOCache alloc] initWithCacheDirectory:[MTCacheManager getCredentialCacheDirectory:CACHE_DIRECTORY_CUR_USER]];
        [self.credentialCache setDefaultTimeoutInterval:DefaultUserCredentialTimeoutInterval];
        
        self.objectCache = [EGOCache globalCache];
    }
    return self;
}


- (void) setCachedCurUser:(MTUserModel *)cachedCurUser {
    [self.credentialCache setObject:cachedCurUser forKey:CURRENT_USER_CACHE_KEY];
}

- (void) setCachedCurUserAccessToken:(NSString *)cachedCurUserAccessToken {
    [self.credentialCache setObject:cachedCurUserAccessToken forKey:CURRENT_USER_ACCESS_TOKEN_KEY];
}

- (MTUserModel*) cachedCurUser {
    MTUserModel* user = (MTUserModel*)[self.credentialCache objectForKey:CURRENT_USER_CACHE_KEY];
    return user;
}

- (NSString*) cachedCurUserAccessToken {
    NSString* token = (NSString*)[self.credentialCache objectForKey:CURRENT_USER_ACCESS_TOKEN_KEY];
    return token;
}

- (void) clearCachedUser {
    [self.credentialCache removeCacheForKey:CURRENT_USER_CACHE_KEY];
}

- (void) clearCachedAccessToken {
    [self.credentialCache removeCacheForKey:CURRENT_USER_ACCESS_TOKEN_KEY];
}

- (void) clearUserData {
    [self clearCachedUser];
    [self clearCachedAccessToken];
}

+ (NSString*) getCredentialCacheDirectory:(NSString*)directoryName {
    NSString* cachesDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
	NSString* oldCachesDirectory = [[[cachesDirectory stringByAppendingPathComponent:[[NSProcessInfo processInfo] processName]] stringByAppendingPathComponent:directoryName] copy];
    
	if([[NSFileManager defaultManager] fileExistsAtPath:oldCachesDirectory]) {
		[[NSFileManager defaultManager] removeItemAtPath:oldCachesDirectory error:NULL];
	}
	cachesDirectory = [[[cachesDirectory stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]] stringByAppendingPathComponent:CACHE_DIRECTORY_CUR_USER] copy];
    
    return cachesDirectory;
}


- (void) clearObjectData {
    [self.objectCache clearCache];
}

- (void) cacheObjectForKey:(NSString*)key object:(id<NSCoding>)object {
    [self.objectCache setObject:object forKey:key];
}

- (id<NSCoding>) objectForKey:(NSString*)key {
    return [self.objectCache objectForKey:key];
}

- (BOOL) isCached:(NSString*)key {
    return [self.objectCache hasCacheForKey:key];
}

@end
