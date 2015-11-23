//
//  SRProduct.h
//  RESTAPI
//
//  Created by Kamil Wasag on 15/11/15.
//  Copyright © 2015 Figure8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import <UIKit/UIKit.h>

@interface SRProduct : JSONModel

@property (nonatomic, assign) int productID;
@property (nonatomic, strong) NSString * _Nonnull name;
@property (nonatomic, strong) NSString * _Nonnull designer;
@property (nonatomic, strong) NSString * _Nonnull price;
@property (nonatomic, strong) NSURL  * _Nonnull url;
@property (nonatomic, strong) NSURL * _Nonnull thumbnailURL;
@property (nonatomic, strong) UIImage<Optional> * _Nullable thumbnailImage;

- (void)downloadThumbnailImageWithCompletionHandler:(void(^ _Nullable)(NSError *_Nullable error))completionHandler;

@end
