//
//  MTNetworkController.m
//  MusTale
//
//  Created by Zenan on 30/5/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTNetworkController.h"
#import "MTSongModel.h"
#import "SVProgressHUD.h"
#import <RestKit/RestKit.h>
#import "MTServerClient.h"
#import <EGOCache/EGOCache.h>
#define FB_PROFILE_URL_FORMAT @"http://graph.facebook.com/%@/picture?type=square"


#define MT_PATH_LOGIN_FACEBOOK @"general/login"
#define MT_PATH_LOGOUT @"logout"
#define MT_PATH_SIGNUP @"general/signup"

static RKObjectMapping* userMapping;
static RKObjectMapping* taleMapping;

@interface MTNetworkController ()
@property (nonatomic,strong) NSString* fbToken;
@property (nonatomic,strong) NSString* mtToken;
@end

@implementation MTNetworkController {
    RKObjectManager *objectManager;
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
        [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"application/json"];
        objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:PATH_BASE_URL]];
        [self addErrorResponseDescriptor];
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
         @"uid":@"userID",
         @"song_id":@"songID",
         @"text":@"text",
         @"voice_url":@"voiceUrl",
         @"create_at":@"createdAt"
         }];
        
        [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:[MTUserModel class] pathPattern:@"user/uid/:ID" method:RKRequestMethodGET]];
        NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userMapping
                                                                                           pathPattern:nil
                                                                                               keyPath:@"user"
                                                                                           statusCodes:statusCodes];
        [objectManager addResponseDescriptor:responseDescriptor];
    }
    return self;
}

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

// Talk to server to login with facebook
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



- (void) addErrorResponseDescriptor {
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[RKErrorMessage class]];
    
    [errorMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"errorMessage"]];
    
    RKResponseDescriptor *errorDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:errorMapping
                                                                                    pathPattern:nil
                                                                                        keyPath:@"error"
                                                                                    statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError)];
    
    [objectManager addResponseDescriptorsFromArray:@[errorDescriptor]];

}

- (void) searchUser:(NSString*)term completeHandler:(NetworkCompleteHandler)handler {
    
}


- (void) getUserWithID:(MTUserModel*)user completeHandler:(NetworkCompleteHandler)handler
{
    
    [objectManager getObject:user path:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        handler(result.array,nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        handler(nil,error);
    }];
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
    
}

@end
