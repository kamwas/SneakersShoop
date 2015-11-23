//
//  SRSRFeaturedProduct.m
//  RESTAPI
//
//  Created by Kamil Wasag on 16/11/15.
//  Copyright © 2015 Figure8. All rights reserved.
//

#import "SRFeaturedProduct.h"

@implementation SRFeaturedProduct

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"productID",
                                                       @"description":@"productDescription",
                                                       @"thumbnail":@"thumbnailURL"
                                                       }];
}

@end