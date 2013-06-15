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



static RKObjectMapping* userMapping;
@implementation MTNetworkController {
    RKObjectManager *serverManager;
}

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
        serverManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:PATH_BASE_URL]];
        [self addErrorResponseDescriptor];
        
        
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
    }
    return self;
}



- (void) addErrorResponseDescriptor {
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[RKErrorMessage class]];
    
    [errorMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"errorMessage"]];
    
    RKResponseDescriptor *errorDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:errorMapping
                                                                                    pathPattern:nil
                                                                                        keyPath:@"error"
                                                                                    statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError)];
    
    [serverManager addResponseDescriptorsFromArray:@[errorDescriptor]];

}



- (void) getUserWithID:(MTUserModel*)user completeHandler:(NetworkCompleteHandler)handler
{
    [serverManager.router.routeSet addRoute:[RKRoute routeWithClass:[MTUserModel class] pathPattern:@"user/uid/:ID" method:RKRequestMethodGET]];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userMapping
                                                                                       pathPattern:nil
                                                                                           keyPath:@"user"
                                                                                       statusCodes:statusCodes];
    [serverManager addResponseDescriptor:responseDescriptor];
    [serverManager getObject:user path:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        handler(result.array,nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        handler(nil,error);
    }];
}


@end
