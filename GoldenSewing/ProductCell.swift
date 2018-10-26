//
//  ProductCell.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 31.08.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var articleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var econom: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var ratingLbl: CosmosView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureCell(_ product: Product, category: Int, star: Bool) {
        // set cell background
        self.backgroundColor = UIColor.CustomColors.burgundy
        
        if (product.category?.id == 1 || product.category?.id == 18) {
            nameLabel.text = product.category?.name
            articleLabel.isHidden = true
            typeLabel.isHidden = true
        } else {
            // set all text labels
            nameLabel.text = product.name?.capitalized
            articleLabel.isHidden = false
            articleLabel.text = "Артикул \(product.id)"
            typeLabel.isHidden = false
            if category == 103 {
                var str = ""
                for val in product.cloth! {
                    str += "\(val), "
                }
                typeLabel.text = "\(str.dropLast(2))"
            } else {
                typeLabel.text = product.subName?.capitalized
            }
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
        
        // set Date
        dateLbl.textColor = UIColor.clear
        if let date = product.seen {
            if !star {
                dateLbl.textColor = UIColor.CustomColors.yellow
                dateLbl.text = (date as Date).toCustomString()
            }
        }
        // set rate
        ratingLbl.isHidden = true
        if product.rating > 0 {
            if star {
                ratingLbl.isHidden = false
                ratingLbl.rating = Double(product.rating)
            }
        }
        
        showSeparator()
    }
}
