//
//  LRFServerConnection.m
//  lystTest
//
//  Created by Kamil Wasag on 12/11/15.
//  Copyright © 2015 Figure8. All rights reserved.
//

#import "SRFServerConnection.h"


@implementation SRFServerConnection

+ (SRFServerConnection* _Nonnull)sharedInstance{
    static SRFServerConnection* singleton;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        singleton = [SRFServerConnection new];
    });
    return singleton;
}

- (NSURL*)getURLForEndpoint:(SRFEndpointsValue* _Nonnull)endpoint forParameters:(NSDictionary<SRFParametersName*,SRFGenderParemetersValue*>* _Nonnull)parameters{
    NSMutableString *urlString =[[kSRFServerBaseAddress stringByAppendingPathComponent:endpoint] mutableCopy];
    [urlString appendString:@"?"];
    for (NSString *key in parameters) {
        [urlString appendFormat:@"%@:%@&",key, parameters[key]];
    }
    [urlString deleteCharactersInRange:NSMakeRange(urlString.length-1, 1)];
    return [NSURL URLWithString:urlString];
}

- (void)addHedersToRequest:(NSMutableURLRequest * _Nonnull)request{
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:[NSString stringWithFormat:@"token %@",kSRFToken] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"GET"];
}

- (NSURLRequest *)urlRequestForEndpoitn:(SRFEndpointsValue* _Nonnull)endpoint forParameters:(NSDictionary<SRFParametersName*,SRFGenderParemetersValue*>* _Nonnull)parameters{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self getURLForEndpoint:endpoint forParameters:parameters]];
    [self addHedersToRequest:request];
    return [request copy];
}

- (void)downloadDataForEndpoint:(SRFEndpointsValue* _Nonnull)endpoint
                  forParameters:(NSDictionary<SRFParametersName*,SRFGenderParemetersValue*>* _Nonnull)parametars
          withCompletionHandler:( void(^ _Nullable )(NSData* _Nullable products, NSError   *_Nullable error))competionHandler{
    
    NSURLRequest *request = [self urlRequestForEndpoitn:endpoint forParameters:parametars];
    [self downloadDataWithRequest:request witchCompletionHandler:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (competionHandler) {
            competionHandler(data,error);
        }
    }];
}

- (void)downloadDataWithRequest:(NSURLRequest * _Nonnull)request
         witchCompletionHandler:(void(^ _Nullable)(NSData* _Nullable data, NSError* _Nullable error))cHandler{
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (cHandler) {
            cHandler(data,error);
        }
    }]resume];
}

- (void)downloadSneakersForGender:(SRFGenderParemetersValue * _Nonnull )gender
                   withPageNumber:(int)pageNumber
            withCompletionHandler:(void(^ _Nullable )(NSArray<SRProduct *>* _Nullable products, NSError   *_Nullable error))competionHandler{
    
    NSDictionary *parameters = @{SRFParametersNames.Gender:gender,
                                 SRFParametersNames.Page:@(pageNumber)};
    [self downloadDataForEndpoint:SRFEndpoints.Sneakers
                    forParameters:parameters
            withCompletionHandler:^(NSData* _Nullable data, NSError * _Nullable error) {
                NSArray<SRProduct *> *products;
                if (data) {
                    products = [SRProduct arrayOfModelsFromData:data error:&error];
                }
                if (competionHandler) {
                        competionHandler(products,error);
                }

    }];
}

- (void)downloadFeaturedForGender:(SRFGenderParemetersValue * _Nonnull)gender
            withComplitionHandler:(void(^ _Nullable)(NSArray<SRFeaturedProduct*>* _Nullable featured, NSError * _Nullable error))completionHander{
    
    
    NSDictionary *parameters = @{SRFParametersNames.Gender:gender};
    [self downloadDataForEndpoint:SRFEndpoints.Featured
                    forParameters:parameters
            withCompletionHandler:^(NSData * _Nullable products, NSError * _Nullable error) {
                //for future purpus if there will be more than one featured product it will be easy to change for array
                SRFeaturedProduct*product = [[SRFeaturedProduct alloc] initWithData:products error:&error];
                NSArray<SRFeaturedProduct*> *featured = nil;
                if (product) {
                    featured = @[[[SRFeaturedProduct alloc] initWithData:products error:&error]];
                }
                if (completionHander) {
                    completionHander(featured,error);
                }
            }];
}
@end
