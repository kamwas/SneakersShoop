//
//  SRSneakersCell.swift
//  Sneakers
//
//  Created by Kamil Wasag on 16/11/15.
//  Copyright © 2015 Figure8. All rights reserved.
//

import UIKit

class SRSneakersCell: UICollectionViewCell {

    @IBOutlet weak var downloadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var sneakersImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var designerLabel: UILabel!

    
    var price:String?{
        set{
            self.priceLabel.text = newValue
        }
        get{
            return self.priceLabel.text
        }
    }
    
    var designer:String?{
        get{
            return self.designerLabel.text
        }
        set{
            self.designerLabel.text = newValue
        }
    }
    
    var image:UIImage?{
        get{
            return self.sneakersImageView.image
        }
        set{
            if let _ = newValue{
                self.downloadingActivityIndicator.stopAnimating()
            }else{
                self.downloadingActivityIndicator.startAnimating()
            }
            self.sneakersImageView.image = newValue
        }
    }

}
