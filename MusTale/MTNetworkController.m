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
#import "MTUserModel.h"
@implementation MTNetworkController

+ (MTNetworkController*) sharedInstance {
    static MTNetworkController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}




+ (void) testLoadSongWithResult:(void(^)(NSArray* success))callback
{    
    RKObjectMapping *songMapping = [RKObjectMapping mappingForClass:[MTSongModel class]];
    [songMapping addAttributeMappingsFromDictionary:@{
     @"trackId":@"trackId",
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
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:songMapping pathPattern:nil keyPath:@"results" statusCodes:statusCodes];
    

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://itunes.apple.com/search?term=daft+punk&limit=10&media=music&entity=song"]];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    
    NSLog(@"start rest query");
    
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        //MTSongModel *song = [mappingResult firstObject];
        RKLogInfo(@"Load collection of Articles: %@", mappingResult.array);
        callback(mappingResult.array);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Operation failed with error: %@", error);
    }];
    
    [operation start];
    
}

+ (void) test {
    // GET a single Article from /articles/1234.json and map it into an object
    // JSON looks like {"article": {"title": "My Article", "author": "Blake", "body": "Very cool!!"}}
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[MTUserModel class]];
    [mapping addAttributeMappingsFromDictionary:@{
     @"uid":@"id",
     @"email":@"email",
     @"fb_id":@"f",
     @"name":@"name",
     @"gender":@"gender",
     @"profile_url":@"profileURL",
     @"fbLocationID":@"fbLocationID",
     }];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping pathPattern:@"/user/:articleID" keyPath:@"user" statusCodes:statusCodes];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://jiaojingping.com/mustale/index.php/api/example/user/uid/1/"]];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        MTUserModel *user = [result firstObject];
        NSLog(@"Mapped the article: %@", user);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Failed with error: %@", [error localizedDescription]);
    }];
    [operation start];
}

@end
