//
//  SRProduct.m
//  RESTAPI
//
//  Created by Kamil Wasag on 15/11/15.
//  Copyright © 2015 Figure8. All rights reserved.
//

#import "SRProduct.h"
#import "SRFServerConnection.h"

typedef void(^ _Nullable CompletionHandler)(NSError *_Nullable error);

@interface SRProduct ()

@property (nonatomic,strong) NSNumber<Ignore>* isDownloading;
@property (nonatomic,strong) NSMutableArray<Ignore>* completionHandlers;


@end

@implementation SRProduct

- (NSArray<Ignore>*)completionHandlers{
    if (!_completionHandlers) {
        _completionHandlers = [NSMutableArray<Ignore> new];
    }
    return _completionHandlers;
}

- (void)downloadThumbnailImageWithCompletionHandler:(void(^ _Nullable)(NSError *_Nullable error))completionHandler{
    
    [self.completionHandlers addObject:completionHandler];
    if (!self.isDownloading.boolValue) {
        self.isDownloading = [NSNumber numberWithBool:FALSE];
        NSURLRequest *thumbnailRequest = [NSURLRequest requestWithURL:self.thumbnailURL];
        [[SRFServerConnection sharedInstance] downloadDataWithRequest:thumbnailRequest
                                               witchCompletionHandler:^(NSData * _Nullable data, NSError * _Nullable error) {
                                                   if (!error) {
                                                       self.thumbnailImage = [UIImage imageWithData:data];
                                                   }
                                                   for (CompletionHandler cHandler in self.completionHandlers) {
                                                       cHandler(error);
                                                   }
                                                   self.isDownloading = [NSNumber numberWithBool:FALSE];
                                               }];
    }
}


+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"productID",
                                                       @"thumbnail":@"thumbnailURL"
                                                       }];
}

@end
