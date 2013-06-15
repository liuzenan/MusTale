//
//  MTItuneController.m
//  MusTale
//
//  Created by Jiao Jing Ping on 15/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MTItuneNetworkController.h"
#import <RestKit/RestKit.h>
#import "MTArtistModel.h"
#import "MTSongModel.h"

#define NETWORK_ITUNE_RESULT_KEY @"results"
#define NETWORK_ITUNE_SEARCH_RESULT_LIMIT @"50"

#define NETWORK_PATH_ITUNE_LOOKUP @"https://itunes.apple.com/lookup?id=%@"
#define NETWORK_PATH_ITUNE_LOOKUP_SONG @"https://itunes.apple.com/lookup?id=%@&entity=song&media=music"
#define NETWORK_PATH_ITUNE_SEARCH @"https://itunes.apple.com/search?term=%@"


static RKObjectMapping* songMapping;
static RKObjectMapping* artistMapping;

@implementation MTItuneNetworkController

+ (MTItuneNetworkController*) sharedInstance {
    static MTItuneNetworkController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id) init {
    if (self = [super init]) {
        // Artist Mapping
        artistMapping = [RKObjectMapping mappingForClass:[MTArtistModel class]];
        [artistMapping addAttributeMappingsFromArray:@[@"artistId",@"artistName",@"artistType",@"artistLinkUrl"]];
        // Song mapping
        songMapping = [RKObjectMapping mappingForClass:[MTSongModel class]];
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

    }
    return self;
}


- (void) testLoadSongWithResult:(void(^)(NSArray* success))callback
{
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:songMapping pathPattern:nil keyPath:@"results" statusCodes:statusCodes];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://itunes.apple.com/search?term=Lana+Del+Rey&limit=10&media=music&entity=song"]];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    
    
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        //MTSongModel *song = [mappingResult firstObject];
        RKLogInfo(@"Load collection of Articles: %@", mappingResult.array);
        callback(mappingResult.array);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Operation failed with error: %@", error);
    }];
    
    [operation start];
}



- (void) searchSongWithTerm:(NSString*)term completeHandler:(NetworkCompleteHandler)handler {
    NSDictionary* param = @{@"limit":NETWORK_ITUNE_SEARCH_RESULT_LIMIT,
                            @"entity":@"song",
                            @"media":@"music"
                            };
    
    [self searchWithTerm:term params:param mapping:songMapping completeHandler:handler];
}


- (void) searchWithTerm:(NSString*)term params:(NSDictionary*)params mapping:(RKObjectMapping*)mapping completeHandler:(NetworkCompleteHandler)handler {
    NSString* base = [NSString stringWithFormat:NETWORK_PATH_ITUNE_SEARCH,term];
    NSString* path = [self constructRequestUrlString:base :params];
    [self getWithPath:path mapping:mapping handler:handler];
}

- (NSString*) constructRequestUrlString:(NSString*)base :(NSDictionary*)params {
    NSMutableString* result = [NSMutableString stringWithString:base];
    for (NSString* key in params) {
        NSLog(@"%@%@",key,[params objectForKey:key]);
        NSString* value = [params objectForKey:key];
        [result appendString:[NSString stringWithFormat:@"&%@=%@",key,value]];
    }
    NSLog(@"Constructed URL:%@",result);
    return result;
}

- (void) getSongWithSongId:(NSString*)songId completeHandler:(NetworkCompleteHandler)handler {
    [self getWithPath:[NSString stringWithFormat:NETWORK_PATH_ITUNE_LOOKUP_SONG,songId] mapping:songMapping handler:handler];
}


- (void) getArtistSongsWithArtistId:(NSString*)artistId completeHandler:(NetworkCompleteHandler)handler {
    [self getWithPath:[NSString stringWithFormat:NETWORK_PATH_ITUNE_LOOKUP_SONG,artistId] mapping:songMapping handler:handler];
}

- (void) getArtistWithArtistId:(NSString*)artistId completeHandler:(NetworkCompleteHandler)handler {
    [self getWithPath:[NSString stringWithFormat:NETWORK_PATH_ITUNE_LOOKUP,artistId] mapping:artistMapping handler:handler];
}


- (void) getWithPath:(NSString*)path mapping:(RKObjectMapping*)mapping handler:(NetworkCompleteHandler)handler{
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                                                       pathPattern:nil
                                                                                           keyPath:NETWORK_ITUNE_RESULT_KEY
                                                                                       statusCodes:statusCodes];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        handler(mappingResult.array,nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        handler(nil,error);
    }];
    [operation start];
}



@end
