//
//  SGServerClient.m
//  StreetGaGaApp
//
//  Created by Xujie Song on 28/05/13.
//  Copyright (c) 2013 StreetGaGa. All rights reserved.
//


#import "MTServerClient.h"

#define MT_SERVER_TERM_AUTHTOKEN @"auth_token"

@implementation MTServerClient

+ (MTServerClient *)sharedInstance
{
    static dispatch_once_t pred;
    static MTServerClient *_sharedMTServerHTTPClient = nil;
    dispatch_once(&pred, ^{ _sharedMTServerHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:PATH_BASE_URL]]; });
    return _sharedMTServerHTTPClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    return self;
}


#pragma private
- (void) post:(NSDictionary*)data
         path:(NSString*)path
      success:(AFHTTPSuccessBlock)successBlock
      failure:(AFHTTPFailBlock)failBlock {
    [self postPath:path parameters:data success:successBlock failure:failBlock];
}

- (void) get:(NSDictionary*)data
        path:(NSString*)path
     success:(AFHTTPSuccessBlock)successBlock
     failure:(AFHTTPFailBlock)failBlock {
    
    [self getPath:path parameters:data success:successBlock failure:failBlock];
}

- (void) postSecure:(NSDictionary*)data
              token:token
               path:(NSString*)path
            success:(AFHTTPSuccessBlock)successBlock
            failure:(AFHTTPFailBlock)failBlock {
    data = [NSMutableDictionary dictionaryWithDictionary:data];
    
    if (data) {
        [data setValue:token forKey:MT_SERVER_TERM_AUTHTOKEN];
    } else {
        data = [NSDictionary dictionaryWithObject:token forKey:MT_SERVER_TERM_AUTHTOKEN];
    }
    [self postPath:path parameters:data success:successBlock failure:failBlock];
}
/*
- (void) postSecureWithFile:(NSMutableDictionary*)data
                      token:token
                   fileData:(NSData*)fileData
                   fileName:(NSString*)fileName
                    fileKey:(NSString*)fileKey
                   fileType:(NSString*)fileType
                       path:(NSString*)path
                    success:(SGClientFileTransterSuccessBlock)successBlock
                    failure:(SGClientFileTransterFail)failBlock
                   progress:(ProgressBlock)progressBlock{
    
    if (data) {
        [data setValue:token forKey:MT_SERVER_TERM_AUTHTOKEN];
    } else {
        data = [NSDictionary dictionaryWithObject:token forKey:MT_SERVER_TERM_AUTHTOKEN];
    }
    
    NSURLRequest *request = [self multipartFormRequestWithMethod:@"POST" path:path parameters:data constructingBodyWithBlock: ^(id <AFMultipartFormData> formData) {
        [formData appendPartWithFileData:fileData name:fileKey fileName:fileName mimeType:fileType];
    }];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:successBlock
                                                                                        failure:failBlock];

    [operation setUploadProgressBlock:progressBlock];
    [operation start];
}*/

- (void) getSecure:(NSDictionary*)data
             token:(NSString*)token
              path:(NSString*)path
           success:(AFHTTPSuccessBlock)successBlock
           failure:(AFHTTPFailBlock)failBlock {
    data = [NSMutableDictionary dictionaryWithDictionary:data];
    if (data) {
        [data setValue:token forKey:MT_SERVER_TERM_AUTHTOKEN];
    } else {
        data = [NSDictionary dictionaryWithObject:token forKey:MT_SERVER_TERM_AUTHTOKEN];
    }
    
    [self getPath:path parameters:data success:successBlock failure:failBlock];
    
}

- (void) putSecure:(NSDictionary*)data
             token:(NSString*)token
              path:(NSString*)path
           success:(AFHTTPSuccessBlock)successBlock
           failure:(AFHTTPFailBlock)failBlock {
    data = [NSMutableDictionary dictionaryWithDictionary:data];
    if (data) {
        [data setValue:token forKey:MT_SERVER_TERM_AUTHTOKEN];
    } else {
        data = [NSDictionary dictionaryWithObject:token forKey:MT_SERVER_TERM_AUTHTOKEN];
    }
    [self putPath:path parameters:data success:successBlock failure:failBlock];
}

- (void) deleteSecure:(NSDictionary*)data
                token:(NSString*)token
                 path:(NSString*)path
              success:(AFHTTPSuccessBlock)successBlock
              failure:(AFHTTPFailBlock)failBlock {
    data = [NSMutableDictionary dictionaryWithDictionary:data];
    if (data) {
        [data setValue:token forKey:MT_SERVER_TERM_AUTHTOKEN];
    } else {
        data = [NSDictionary dictionaryWithObject:token forKey:MT_SERVER_TERM_AUTHTOKEN];
    }
    [self deletePath:path parameters:data success:successBlock failure:failBlock];
}



@end
