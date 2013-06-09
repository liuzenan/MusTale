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

@implementation MTNetworkController

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

@end
