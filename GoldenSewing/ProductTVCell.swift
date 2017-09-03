//
//  ProductTVCell.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 31.07.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class ProductTVCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var articleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var econom: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ product: Product, category: Int) {
        // set cell background
        self.backgroundColor = UIColor.CustomColors.burgundy
        
        // set all text labels
        nameLabel.text = product.name?.capitalized
        articleLabel.text = "Артикул \(product.id)"
        if category == 103 {
            var str = ""
            for val in product.cloth! {
                str += "\(val), "
            }
            typeLabel.text = String(str.characters.dropLast(2))
        } else {
            typeLabel.text = product.subName?.capitalized
        }
        
        // set image
        if product.featuredImg == nil {
            imgView?.image = UIImage(named: "Placeholder")
        } else {
            let data = product.featuredImg! as Data
            imgView?.image = UIImage(data: data)
        }
        
        // show lowCost mark
        econom?.image = UIImage(named: "Econom")
        econom?.isHidden = product.isLowCost ? false : true
        
        // set image view
        imgView?.layer.cornerRadius = imgView.frame.height/10
        imgView?.layer.borderWidth = 1.0
        imgView?.layer.borderColor = (UIColor.CustomColors.yellow).cgColor
        imgView?.clipsToBounds = true
        
        showSeparator()
    }
}

