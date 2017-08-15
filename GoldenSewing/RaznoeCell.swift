//
//  RaznoeCell.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 12.08.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class RaznoeCell: UICollectionViewCell {
        
        // MARK: - Outlets -
        @IBOutlet weak var imgView: UIImageView!
    
        func configureCell(_ product: Product) {
            
            // set image
            if product.featuredImg == nil {
                imgView?.image = UIImage(named: "Placeholder")
            } else {
                let data = product.featuredImg! as Data
                imgView?.image = UIImage(data: data)
            }
            
            // set image view
            imgView?.layer.cornerRadius = imgView.frame.height/10
            imgView?.layer.borderWidth = 1.0
            imgView?.layer.borderColor = (UIColor.CustomColors.yellow).cgColor
            imgView?.clipsToBounds = true
            
        }
}
