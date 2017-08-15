//
//  CollViewCell.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 10.08.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class CollViewCell: UICollectionViewCell {
    
    // MARK: - Outlets -
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    func configureCell(_ product: Product) {
        
        // set all text labels
        titleLabel.text = product.name?.capitalized
        
        // set image
        if product.featuredImg == nil {
            imgView?.image = UIImage(named: "Placeholder")
        } else {
            let data = product.featuredImg! as Data
            imgView?.image = UIImage(data: data)
        }
        
    }

}
