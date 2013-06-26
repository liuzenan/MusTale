//
//  MTNetworkController.m
//  MusTale
//
//  Created by Zenan on 30/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTNetworkController.h"
#import "SVProgressHUD.h"
#import <RestKit/RestKit.h>
#import "MTServerClient.h"
#import <EGOCache/EGOCache.h>
#import "RKObjectMappingOperationDataSource.h"
#import "MTS3Controller.h"
#define LOG_S(tag,data) if(self.isDebugMode) NSLog(@"%@ success with data %@",tag,data)
#define LOG_F(tag,error) if(self.isDebugMode) NSLog(@"%@ fail with error %@",tag,error.localizedDescription)
#define int2string(i) [NSString stringWithFormat:@"%d",i]

#define FB_PROFILE_URL_FORMAT @"http://graph.facebook.com/%@/picture?type=square"


#define MT_PATH_LOGIN_FACEBOOK @"general/login"
#define MT_PATH_LOGOUT @"logout"
#define MT_PATH_SIGNUP @"general/signup"

#define MT_PATH_USER @"users" //uid
#define MT_PATH_SONG @"songs" //songid

#define MT_PATH_SONG_TALE @"songs/tales/song_id/%@" //uid-songid
#define MT_PATH_TALE @"tales"
#define MT_PATH_TALE_LIKE @"tales/likes/tale_id/%@"
#define MT_PATH_TALE_UNLIKE @"tales/unlikes/tale_id/%@"

#define MT_PATH_LISTEN @"listens"  //songid-userid
#define MT_PATH_LISTEN_POPULAR @"listens/popular"

#define MT_PATH_USER_DEDICATION @"users/dedications/uid/%@" // songid-userid(from)-userid(to)
#define MT_PATH_DEDICATION @"users/dedications"
#define MT_PATH_READ_DEDICATION @"dedications/read"

#define MT_PATH_COMMENT @"tales/comments" // uid-songid (tale)-songid (from)
#define MT_PATH_COMMENT_TALE @"tales/comments/tale_id/%@"


static RKObjectMapping* userMapping;
static RKObjectMapping* taleMapping;
static RKObjectMapping* songMapping;
static RKObjectMapping* listenMapping;
static RKObjectMapping* commentMapping;
static RKObjectMapping* dedicationMapping;

@interface MTNetworkController ()
@property (nonatomic,strong) NSString* fbToken;
@property (nonatomic,strong) NSString* mtToken;
@end

@implementation MTNetworkController {
    //RKObjectManager *objectManager;
    MTServerClient* serverClient;
    MTFBHelper* fbHelper;
}
@synthesize mtToken = _mtToken;

+ (MTNetworkController*) sharedInstance {
    static MTNetworkController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id) init {
    if (self = [super init]) {
        //[self addErrorResponseDescriptor];
        self.isDebugMode = YES;
        self.currentUser = [MTUserModel new];
        serverClient = [MTServerClient sharedInstance];
        fbHelper = [MTFBHelper sharedFBHelper];
           
        // User mapping
        userMapping = [RKObjectMapping mappingForClass:[MTUserModel class]];
        [userMapping addAttributeMappingsFromDictionary:@{
         @"uid":@"ID",
         @"email":@"email",
         @"fb_id":@"fbID",
         @"name":@"name",
         @"gender":@"gender",
         @"profile_url":@"profileURL",
         @"fbLocationID":@"fbLocationID",
         }];
        taleMapping = [RKObjectMapping mappingForClass:[MTTaleModel class]];
        [taleMapping addAttributeMappingsFromDictionary:@{
         @"tale_id":@"ID",
         @"song_id":@"songID",
         @"text":@"text",
         @"is_public":@"isPublic",
         @"is_anonymous":@"isAnonymous",
         @"is_front":@"isFront",
         @"voice_url":@"voiceUrl",
         @"create_at":@"createdAt",
         @"is_liked":@"isLikedByCurrentUser",
         @"like_count":@"likeCount",
         @"comment_count":@"commentCount"
         }];
        [taleMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"from_user" toKeyPath:@"user" withMapping:userMapping]];
        
        // Song mapping
        songMapping = [RKObjectMapping mappingForClass:[MTSongModel class]];
        [songMapping addAttributeMappingsFromDictionary:@{
         @"song_id":@"ID",
         @"listen_count":@"listenCount",
         @"itune_track_id":@"trackId",
         @"trackName":@"trackName",
         @"artistName":@"artistName",
         @"trackViewUrl":@"trackViewUrl",
         @"artistId":@"artistId",
         @"artworkUrl100":@"artworkUrl100",
         @"collectionName":@"collectionName",
         @"collectionId":@"collectionId",
         @"country":@"country",
         @"previewUrl":@"previewUrl",
         @"primaryGenreName":@"primaryGenreName"
         
         }];
        listenMapping = [RKObjectMapping mappingForClass:[MTListenModel class]];
        [listenMapping addAttributeMappingsFromDictionary:@{
         @"song_id":@"songID",
         @"uid":@"userID",
         @"listen_count":@"listenCount"
         }];
        
        commentMapping = [RKObjectMapping mappingForClass:[MTCommentsModel class]];
        [commentMapping addAttributeMappingsFromDictionary:@{
         @"uid":@"userID",
         @"tale_id":@"taleID",
         @"content":@"content",
         @"created_at":@"createdAt"
         }];
        dedicationMapping = [RKObjectMapping mappingForClass:[MTDedicationModel class]];
        [dedicationMapping addAttributeMappingsFromDictionary:@{
         @"dedication_id":@"ID",
         @"is_public":@"isPublic",
         @"is_anonymous":@"isAnonymous",
         @"has_read":@"hasRead",
         @"created_at":@"createdAt",
         @"tale_id":@"taleId"
         }];
        [dedicationMapping addRelationshipMappingWithSourceKeyPath:@"from" mapping:userMapping];
        [dedicationMapping addRelationshipMappingWithSourceKeyPath:@"to" mapping:userMapping];
        [dedicationMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"tale" toKeyPath:@"tale" withMapping:taleMapping]];
    }
    return self;
}

/*
- (void) addErrorResponseDescriptor {
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[RKErrorMessage class]];
    
    [errorMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"errorMessage"]];
    
    RKResponseDescriptor *errorDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:errorMapping
                                                                                    pathPattern:nil
                                                                                        keyPath:@"error"
                                                                                    statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError)];
    
    [objectManager addResponseDescriptorsFromArray:@[errorDescriptor]];
    
}*/


#pragma mark login/out/signup
- (BOOL) isLoggedIn {
    return (_currentUser && self.mtToken);
}

- (void) clearUserData {
    _currentUser = [MTUserModel new];
    self.mtToken = nil;
    [[EGOCache globalCache] removeCacheForKey:@"auth_token"];
    NSLog(@"removed cached user");
}


- (NSString*)fbToken {
    NSLog(@"current fbToken %@",[fbHelper fbToken]);
    if (fbHelper) {
        return [fbHelper fbToken];
    }
    return nil;
}

- (NSString*)mtToken {
    if (_mtToken) {
        return _mtToken;
    } else if ([[EGOCache globalCache] stringForKey:@"auth_token"] && ![[[EGOCache globalCache] stringForKey:@"auth_token"] isEqualToString:@""]) {
        _mtToken = [[EGOCache globalCache] stringForKey:@"auth_token"];
        NSLog(@"Get cached mtToken %@",[[EGOCache globalCache] stringForKey:@"auth_token"]);
        return _mtToken;
    }
    return nil;
}


- (void) setMtToken:(NSString *)mtToken {
    _mtToken = mtToken;
    [[EGOCache globalCache] setString:mtToken forKey:@"auth_token"];
    NSLog(@"Cached mtToken %@",mtToken);
}



- (void) fbLogin:(FBLoginCompleteHandler)completeHandler {
    
    // if exist a fb session, try to login with it
    if ([fbHelper isOpen]) {
        NSLog(@"Existing fb session is available");
        [self loadUserInfo:^(void){
            [self loginWithFBToServer:completeHandler];
        }];
        return;
    }
    
    [fbHelper openSessionWithAllowLoginUI:YES completionHandler:^(FBSession *   session, FBSessionState state, NSError *error) {
        switch (state) {
            case FBSessionStateOpen: {
                [self loadUserInfo:^(void){
                    [self loginWithFBToServer:completeHandler];
                }];
            }
                break;
            case FBSessionStateClosed:
            case FBSessionStateClosedLoginFailed:
                [FBSession.activeSession closeAndClearTokenInformation];
                break;
            default:
                break;
        }
        if (error) {
            completeHandler(NO,error);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:FBSessionStateChangedNotification object:session];
        
    }];
}

- (void) logout:(NetworkCompleteHandler)completeHandler {
    [serverClient getSecure:nil
                      token:self.mtToken
                       path:MT_PATH_LOGOUT
                    success:^(AFHTTPRequestOperation *operation, id data) {
                        NSLog(@"Logout user with token %@ successfully",self.mtToken);
                        [self clearUserData];
                        completeHandler(nil,nil);
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        completeHandler(nil,error);
                    }];
}

- (void) loginWithFBToServer:(FBLoginCompleteHandler)completeHanlder {
    NSMutableDictionary* data = [NSMutableDictionary dictionary];
    [data setValue:self.fbToken forKey:@"fb_token"];
    
    [serverClient post:data
                  path:MT_PATH_LOGIN_FACEBOOK
               success:^(AFHTTPRequestOperation *operation, id data) {
                   // Existing User
                   NSLog(@"Login via fb Success with data %@",data);
                   self.mtToken = [(NSDictionary*)data objectForKey:@"auth_token"];
                   self.currentUser.ID = [(NSDictionary*)data objectForKey:@"uid"];
                   completeHanlder(YES,nil);
               }
               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   if ([[operation response] statusCode] == 401) {
                       // First time user
                       NSLog(@"Login fail, first time user");
                       completeHanlder(NO,nil);
                   } else {
                       // Other error
                       NSLog(@"Login fail, other error %@",error.localizedDescription);
                       completeHanlder(NO,error);
                   }
               }];
}

- (void) signUpViaFacebook:(NetworkCompleteHandler)handler {
    NSMutableDictionary* data = [NSMutableDictionary dictionary];
    [data setValue:self.fbToken forKey:@"fb_token"];
    [data setValue:self.currentUser.email forKey:@"email"];
    [data setValue:self.currentUser.name forKey:@"name"];
    [data setValue:self.currentUser.fbLocationID forKey:@"fb_location_id"];
    [data setValue:self.currentUser.gender forKey:@"gender"];
    [data setValue:self.currentUser.link forKey:@"link"];
    [data setValue:self.currentUser.profileURL forKey:@"profile_url"];
    
    [serverClient post:data path:MT_PATH_SIGNUP success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Sign up successful %@",responseObject);
        self.mtToken = [responseObject objectForKey:@"auth_token"];
        self.currentUser.ID =[responseObject objectForKey:@"uid"];
        handler(self.currentUser,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Sign up Error %@",error);
        handler(nil,error);
    }];
    
}


- (void) loadUserInfo:(void (^)(void))completeHandler {
    
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
         if (!error) {
             self.currentUser.name = [user objectForKey:@"name"];
             self.currentUser.email = [user objectForKey:@"email"];
             self.currentUser.gender = [user objectForKey:@"gender"];
             self.currentUser.fbID = [user objectForKey:@"id"];
             self.currentUser.profileURL = [self getProfileUrlFromID:user.id];
             self.currentUser.link = [user objectForKey:@"link"];
             self.currentUser.fbLocationID = [[user objectForKey:@"location"] objectForKey:@"id"];
             
             completeHandler();
         } else {
             
             completeHandler();
         }
     }];
}


- (NSString*) getProfileUrlFromID:(NSString*)ID {
    return [NSString stringWithFormat:FB_PROFILE_URL_FORMAT,ID];
}

#pragma mark songs
- (void) postSong:(MTSongModel*)song completeHandler:(NetworkCompleteHandler)handler {
    NSDictionary* songData = [self objectToDictionary:song inverseMapping:songMapping.inverseMapping rootPath:nil];
    [serverClient postSecure:songData token:self.mtToken path:MT_PATH_SONG success:^(AFHTTPRequestOperation *operation, id responseObject) {
        song.ID = [responseObject objectForKey:@"song_id"];
        LOG_S(@"postSong", responseObject);
        handler(song,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LOG_F(@"postSong", error);
        handler(nil,error);
    }];
}

- (void) postListenTo:(MTSongModel*)song completeHandler:(NetworkCompleteHandler)handler {
    [self postSong:song completeHandler:^(id data, NSError *error) {
        if (data) {
            MTSongModel* song = (MTSongModel*)data;
            assert(song!=nil);
            [serverClient postSecure:@{@"song_id":song.ID} token:self.mtToken path:MT_PATH_LISTEN success:^(AFHTTPRequestOperation *operation, id responseObject) {
                assert(song.ID != nil);
                LOG_S(@"post listen", responseObject);
                MTListenModel* listenTo = [MTListenModel new];
                [self dictionaryToObject:responseObject destination:listenTo objectMapping:listenMapping];
                handler(listenTo,nil);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                LOG_F(@"post listen", error);
                handler(nil,error);
            }];
        } else {
            handler(nil,error);
        }
    }];
}

- (void) getPopularSongs:(NSInteger)limit completeHandler:(NetworkCompleteHandler)handler {
    [serverClient getSecure:@{@"limit":int2string(limit)} token:self.mtToken path:MT_PATH_LISTEN_POPULAR success:^(AFHTTPRequestOperation *operation, id responseObject) {
        LOG_S(@"get popular", responseObject);
        NSMutableArray* songs = [NSMutableArray array];
        for (NSDictionary* songInfo in responseObject) {
            MTSongModel* song = [MTSongModel new];
            [self dictionaryToObject:songInfo destination:song objectMapping:songMapping];
            [songs addObject:song];
        }
        
        handler(songs,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LOG_F(@"get popular", error);
    }];
}

- (void) postVoiceTale:(NSData*)voiceData tale:(MTTaleModel*)tale to:(MTSongModel*)song completeHandler:(NetworkCompleteHandler)handler {
    NSString* tag =@"post voice tale";
    [[MTS3Controller sharedInstance] uploadSoundToS3Bucket:voiceData Completion:^(BOOL success, NSString *soundPath) {
        if (success) {
            LOG_S(tag, soundPath);
            tale.voiceUrl = soundPath;
            [self postTale:tale to:song completeHandler:handler];
        } else {
            NSError* err =[NSError errorWithDomain:@"MT" code:999 userInfo:@{@"localizedDescription":@"upload voice failed"}];
            LOG_F(tag, err);
            handler(nil,err);
        }
    }];
}

#pragma mark tale
- (void) postTale:(MTTaleModel*)tale to:(MTSongModel*)song completeHandler:(NetworkCompleteHandler)handler {
    NSDictionary* taleData = [self objectToDictionary:tale inverseMapping:taleMapping.inverseMapping rootPath:nil];
    assert(song.ID!=nil);
    [serverClient postSecure:taleData token:self.mtToken
                        path:[NSString stringWithFormat:MT_PATH_SONG_TALE,song.ID]
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         LOG_S(@"post tale", responseObject);
                         [self dictionaryToObject:responseObject destination:tale objectMapping:taleMapping];
                         handler(tale,nil);
                     }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         LOG_F(@"post tale", error);
                     }];
}

- (void) likeTale:(NSString*)taleID compeleteHandler:(NetworkCompleteHandler)handler {
    assert(taleID!=nil);
    [serverClient postSecure:nil token:self.mtToken path:[NSString stringWithFormat:MT_PATH_TALE_LIKE,taleID] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        LOG_S(@"like", responseObject);
        //NSInteger likeCount = [ intValue];
        //handler(likeCount,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LOG_F(@"like", error);
        handler(nil,error);
    }];
}

- (void) unlikeTale:(NSString*)taleID compeleteHandler:(NetworkCompleteHandler)handler {
    assert(taleID!=nil);
    [serverClient postSecure:nil
                       token:self.mtToken
                        path:[NSString stringWithFormat:MT_PATH_TALE_UNLIKE,taleID]
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
        LOG_S(@"unlike", responseObject);
    }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LOG_F(@"unlike", error);
    }];
}

- (void) postCommentToTale:(MTCommentsModel*)comment completeHandler:(NetworkCompleteHandler)handler {
    assert(comment.taleID!=nil);
    NSDictionary* commentData = [self objectToDictionary:comment inverseMapping:commentMapping.inverseMapping rootPath:nil];
    [serverClient postSecure:commentData
                       token:self.mtToken
                        path:MT_PATH_COMMENT
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         LOG_S(@"post comment", responseObject);
                         
                         [self dictionaryToObject:responseObject destination:comment objectMapping:commentMapping];
                         handler(comment,nil);
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         LOG_F(@"post comment", error);
                         handler(nil,error);
                     }];
}

- (void) getTalesOfSong:(NSString*)songId completeHandler:(NetworkCompleteHandler)handler {
    assert(songId!=nil);
    [serverClient getSecure:nil
                      token:self.mtToken
                       path:[NSString stringWithFormat:MT_PATH_SONG_TALE,songId]
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        LOG_S(@"get tale", responseObject);
                        NSArray* tales = [self arrayToObjects:responseObject class:[MTTaleModel class] objectMapping:taleMapping];
                        handler(tales,nil);
                    }
                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        LOG_F(@"get tale", error);
                        handler(nil,error);
                    }];
}

- (void) getCommentsOfTale:(NSString*)taleId completeHandler:(NetworkCompleteHandler)handler {
    assert(taleId!=nil);
    [serverClient getSecure:nil token:self.mtToken
                       path:[NSString stringWithFormat:MT_PATH_COMMENT_TALE,taleId]
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        LOG_S(@"get tale", responseObject);
                        NSArray* comments = [self arrayToObjects:responseObject class:[MTCommentsModel class] objectMapping:commentMapping];
                        handler(comments,nil);
                    }
                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        LOG_F(@"get tale", error);
                        handler(nil,error);
                    }];
}

#pragma mark user 
- (void) getUserInfo:(MTUserModel*)user completehandler:(NetworkCompleteHandler)handler {
    NSString* path = @"%@/user/%@/%@";
    if (user.ID) {
        path = [NSString stringWithFormat:path,MT_PATH_USER,@"uid",user.ID];
    } else if (user.fbID){
        path = [NSString stringWithFormat:path,MT_PATH_USER,@"fb_id",user.fbID];
    } else {
        NSError* error = [NSError errorWithDomain:@"MT" code:1000 userInfo:@{@"error":@"missing parameter to get user"}];
        handler(nil,error);
    }
    [serverClient getSecure:nil
                      token:self.mtToken
                       path:path
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        LOG_S(@"Get user info", responseObject);
                        [self dictionaryToObject:responseObject destination:user objectMapping:userMapping];
                        handler(user,nil);
                    }
                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        LOG_F(@"Get user info", error);
                        handler(nil,error);
                    }];
}

#pragma mark dedication 
- (void) postDedication:(MTDedicationModel*)dedication toUser:(NSString*)userId completeHandler:(NetworkCompleteHandler)handler {
    assert(userId!=nil);
    NSString *tag = @"post dedication";
    NSDictionary* dedicationData = [self objectToDictionary:dedication inverseMapping:dedicationMapping.inverseMapping rootPath:nil];
    [serverClient postSecure:dedicationData
                       token:self.mtToken
                        path:[NSString stringWithFormat:MT_PATH_USER_DEDICATION,userId]
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         LOG_S(tag, responseObject);
                         [self dictionaryToObject:dedicationData destination:dedication objectMapping:dedicationMapping];
                         handler(dedication,nil);
                     }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         LOG_F(tag, error);
                         handler(nil,error);
                     }];
}

- (void) getDedicationsFromUser:(NSString*)from toUser:(NSString*)to completeHandler:(NetworkCompleteHandler)handler {
    assert(!(from==nil && to==nil));
    NSString* tag = @"get dedication";
    NSDictionary* data;
    
    if (from && to) {
        data =@{@"from":from,@"to":to};
    } else if(from){
        data =@{@"from":from};
    } else {
        data =@{@"to":to};
    }
    NSLog(@"%@",data);
    [serverClient getSecure:data token:self.mtToken path:MT_PATH_DEDICATION success:^(AFHTTPRequestOperation *operation, id responseObject) {
        LOG_S(tag, responseObject);
        NSArray* dedications = [self arrayToObjects:responseObject class:[MTDedicationModel class] objectMapping:dedicationMapping];
        handler(dedications,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LOG_F(tag, error);
        handler(nil,error);
    }];
}

- (void) postReadDedication:(MTDedicationModel*)dedication completeHandler:(NetworkCompleteHandler)handler {
    NSString* tag = @"post read";
    NSDictionary* data = @{@"dedication_id":dedication.ID};
    [serverClient postSecure:data token:self.mtToken path:MT_PATH_READ_DEDICATION success:^(AFHTTPRequestOperation *operation, id responseObject) {
        LOG_S(tag, responseObject);
        dedication.hasRead = YES;
        handler(dedication,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LOG_F(tag, error);
        handler(nil,error);
    }];
}


#pragma mark helper
- (NSDictionary*) objectToDictionary:(id)obj inverseMapping:(RKObjectMapping*)mapping rootPath:(NSString*)root{
    RKRequestDescriptor * requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:mapping objectClass:[obj class] rootKeyPath:root];
    NSError *error = nil;
    return [RKObjectParameterization parametersWithObject:obj requestDescriptor:requestDescriptor error:&error];
}

- (BOOL) dictionaryToObject:(NSDictionary*)representation destination:(id)obj objectMapping:(RKObjectMapping*)objMapping{
    
    RKMappingOperation *mappingOperation = [[RKMappingOperation alloc] initWithSourceObject:representation destinationObject:obj mapping:objMapping];

    RKObjectMappingOperationDataSource *dataSource = [RKObjectMappingOperationDataSource new];
    mappingOperation.dataSource = dataSource;
    NSError *error = nil;
    BOOL success = [mappingOperation performMapping:&error];
    if (!success) {
        LOG_F(@"Mappign fail", error);
    }
    return success;
   //[mappingOperation start];
}

- (NSArray*) arrayToObjects:(NSArray*)array class:(Class)class objectMapping:(RKObjectMapping*)objMapping {
    NSMutableArray* result = [NSMutableArray array];
    for (NSDictionary* data in array) {
        id obj = [[class alloc] init];
        [self dictionaryToObject:data destination:obj objectMapping:objMapping];
        [result addObject:obj];
    }
    return result;
}

- (void) registerNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNetworkDown:)
                                                 name:APP_NETWORK_DOWN
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDidBecomeActive:)
                                                 name:APP_STATUS_DID_ACTIVE
                                               object:nil];
}

- (void) handleDidBecomeActive:(NSNotification*)notif {
    NSLog(@"Networkclient handling did active",nil);
    
}

- (void) handleNetworkDown:(NSNotification*)notif  {
    NSLog(@"Networkclient handling network down",nil);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                    message:@"You must be connected to the internet to use this app."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];

}

@end
