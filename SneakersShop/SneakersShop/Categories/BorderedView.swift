//
//  BorderedView.swift
//  SneakersShop
//
//  Created by Kamil Wasag on 16/11/15.
//  Copyright © 2015 Figure8. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var borderColor:UIColor? {
        get {
            if let color = self.layer.borderColor {
                return UIColor(CGColor: color)
            }
            return nil
        }
        
        set{
            self.layer.borderColor = newValue?.CGColor
        }
    }
    
    @IBInspectable var borderWidth:CGFloat {
        get{
            return self.layer.borderWidth
        }
        set{
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var cornerRadius:CGFloat {
        get{
            return self.layer.cornerRadius
        }
        set{
            self.layer.cornerRadius = newValue
        }
    }
}