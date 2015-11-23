//
//  SRFConstans.h
//  lystTest
//
//  Created by Kamil Wasag on 12/11/15.
//  Copyright © 2015 Figure8. All rights reserved.
//


#ifndef SRFConstans_h
#define SRFConstans_h
#import <Foundation/Foundation.h>


const static NSString * _Nonnull kSRFServerBaseAddress = @"http://www.fakeSneakersShoppAddress.com";
const static NSString * _Nonnull kSRFToken = @"fakeTokenToSneakersShoop";

typedef NSString SRFParametersName;
struct SRFParametersNamesStruct{
    SRFParametersName const __unsafe_unretained * _Nonnull Gender;
    SRFParametersName const __unsafe_unretained * _Nonnull Page;
};

typedef NSString SRFGenderParemetersValue;
struct SRFGenderParemetersValuesStruct {
    SRFGenderParemetersValue const __unsafe_unretained  * _Nonnull GenderMale;
    SRFGenderParemetersValue const __unsafe_unretained  * _Nonnull GenderFemale;
};

typedef NSString SRFEndpointsValue;
struct SRFEndpointsValuesStruct {
    SRFEndpointsValue const __unsafe_unretained  * _Nonnull Sneakers;
    SRFEndpointsValue const __unsafe_unretained  * _Nonnull Featured;
};

extern const struct SRFGenderParemetersValuesStruct SRFGenderParemeters;
extern const struct SRFEndpointsValuesStruct SRFEndpoints;
extern const struct SRFParametersNamesStruct SRFParametersNames;

#endif /* SRFConstans_h */
