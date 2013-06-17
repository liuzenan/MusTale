//
//  SGServerClient.h
//  StreetGaGaApp
//
//  Created by Xujie Song on 28/05/13.
//  Copyright (c) 2013 StreetGaGa. All rights reserved.
//

#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"


// A singleton AFHTTPClient that handles API interactions with StreetGaGa Server
// Only Accept JSON responses


@interface MTServerClient : AFHTTPClient

+ (MTServerClient*) sharedInstance;

typedef void (^AFHTTPSuccessBlock)(AFHTTPRequestOperation *operation , id responseObject);
typedef void (^AFHTTPFailBlock)(AFHTTPRequestOperation *operation, NSError *error);


- (void) post:(NSDictionary*)data
         path:(NSString*)path
      success:(AFHTTPSuccessBlock)successBlock
      failure:(AFHTTPFailBlock)failBlock;

- (void) get:(NSDictionary*)data
        path:(NSString*)path
     success:(AFHTTPSuccessBlock)successBlock
     failure:(AFHTTPFailBlock)failBlock;

- (void) postSecure:(NSDictionary*)data
              token:token
               path:(NSString*)path
            success:(AFHTTPSuccessBlock)successBlock
            failure:(AFHTTPFailBlock)failBlock;

- (void) getSecure:(NSDictionary*)data
             token:(NSString*)token
              path:(NSString*)path
           success:(AFHTTPSuccessBlock)successBlock
           failure:(AFHTTPFailBlock)failBlock;

- (void) putSecure:(NSDictionary*)data
             token:(NSString*)token
              path:(NSString*)path
           success:(AFHTTPSuccessBlock)successBlock
           failure:(AFHTTPFailBlock)failBlock;

- (void) deleteSecure:(NSDictionary*)data
                token:(NSString*)token
                 path:(NSString*)path
              success:(AFHTTPSuccessBlock)successBlock
              failure:(AFHTTPFailBlock)failBlock;
@end
