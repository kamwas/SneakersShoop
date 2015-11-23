//
//  Unamnaged<NSString>.swift
//  SneakersShop
//
//  Created by Kamil Wasag on 15/11/15.
//  Copyright © 2015 Figure8. All rights reserved.
//

import Foundation

extension Unmanaged where Instance : NSString{
    var unretainedString:String {
        return self.takeUnretainedValue() as String
    }
}