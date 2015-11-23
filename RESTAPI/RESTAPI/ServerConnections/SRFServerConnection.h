//
//  LRFServerConnection.h
//  lystTest
//
//  Created by Kamil Wasag on 12/11/15.
//  Copyright © 2015 Figure8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRFConstans.h"
#import "SRProduct.h"
#import "SRFeaturedProduct.h"

@interface SRFServerConnection : NSObject

+ (SRFServerConnection* _Nonnull)sharedInstance;

- (void)downloadDataWithRequest:(NSURLRequest * _Nonnull)request
         witchCompletionHandler:(void(^ _Nullable)(NSData* _Nullable data, NSError* _Nullable error))cHandler;

- (void)downloadSneakersForGender:(SRFGenderParemetersValue * _Nonnull )gender
                   withPageNumber:(int)pageNumber
            withCompletionHandler:(void(^ _Nullable )(NSArray<SRProduct *>* _Nullable products, NSError *_Nullable error))competionHandler;

- (void)downloadFeaturedForGender:(SRFGenderParemetersValue * _Nonnull)gender
            withComplitionHandler:(void(^ _Nullable)(NSArray<SRFeaturedProduct*>* _Nullable featured, NSError * _Nullable error))completionHander;

@end
