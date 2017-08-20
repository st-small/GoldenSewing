//
//  UnfoldingCell.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 16.08.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class UnfoldingCell: FoldingCell {

    // MARK: - Outlets -

    @IBOutlet weak var thumbnailImg: UIImageView!
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var articleLbl: UILabel!
    
    @IBOutlet weak var subNameLbl: UILabel!
    
    @IBOutlet weak var economImg: UIImageView!
    
    @IBOutlet weak var bigTitleLbl: UILabel!
    
    @IBOutlet weak var bigImg: UIImageView!
    @IBOutlet weak var economBig: UIImageView!
    
    @IBOutlet weak var subnameBig: UILabel!
    @IBOutlet weak var articleBig: UILabel!
    @IBOutlet weak var clothBig: UILabel!
    
    @IBOutlet weak var inlayProperties: UILabel!
    @IBOutlet weak var ratingLbl: CosmosView!
    
    // MARK: - Properties -
    
    
    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.borderWidth = 1
        foregroundView.layer.borderColor = UIColor.CustomColors.yellow.cgColor
        foregroundView.layer.backgroundColor = UIColor.CustomColors.burgundy.cgColor
        
        foregroundView.layer.masksToBounds = true
        
        super.awakeFromNib()
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.0, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2]
        return durations[itemIndex]
    }
    
    func configureCell(_ product: Product, category: Int) {
        // set cell background
        self.backgroundColor = UIColor.CustomColors.burgundy
        
        // set all text labels
        titleLbl.text = product.name?.capitalized
        bigTitleLbl.text = product.name?.capitalized
        articleLbl.text = "Артикул: \(product.id)"
        articleBig.text = articleLbl.text
        
        var str = ""
        if product.cloth != nil {
            for val in product.cloth! {
                str += "\(val), "
            }
            
            clothBig.text = "Ткань: \(String(str.characters.dropLast(2)))"
            clothBig.isHidden = false
        } else {
            clothBig.isHidden = true
        }
        
        if category == 103 {
            clothBig.isHidden = true
            subNameLbl.text = String(str.characters.dropLast(2))
            subnameBig.text = String(str.characters.dropLast(2))
        } else {
            if product.subName != nil || product.subName != "" {
                subNameLbl.text = product.subName?.capitalized
                subNameLbl.isHidden = false
                subnameBig.text = product.subName?.capitalized
                subnameBig.isHidden = false
            } else {
                subNameLbl.isHidden = true
                subnameBig.isHidden = true
            }

        }
        
        var tempString = ""
        // set methodProperties
        var str3 = ""
        if product.methodVal != nil {
            for val in product.methodVal! {
                str3 += "\(val), "
            }
            tempString = "Способ изготовления: \(String(str3.characters.dropLast(2)))\n\n"
        }
        
        // set inlayProperties
        var str2 = ""
        if product.inlay != nil {
            for val in product.inlay! {
                str2 += "\(val), "
            }
            tempString += "Инкрустация: \(String(str2.characters.dropLast(2)))"
        }
        
        // for fabricsProperties
        if product.pattern != nil {
            tempString += "Рисунок (паттерн): \((product.pattern)!)\n\n"
        }
        
        if product.width != nil {
            tempString += "Ширина ткани: \((product.width)!)\n\n"
        }
        
        var str4 = ""
        if product.color != nil {
            for val in product.color! {
                str4 += "\(val), "
            }
            tempString += "Цветовая гамма: \(String(str4.characters.dropLast(2)))"
        }
        
        if tempString != "" {
            inlayProperties.text = tempString
            inlayProperties.isHidden = false
        } else {
            inlayProperties.isHidden = true
        }
        
        // set image
        if product.featuredImg == nil {
            thumbnailImg?.image = UIImage(named: "Placeholder")
            bigImg?.image = thumbnailImg.image
        } else {
            let data = product.featuredImg! as Data
            thumbnailImg?.image = UIImage(data: data)
            bigImg.image = thumbnailImg.image
        }
        
        // show lowCost mark
        economImg?.image = UIImage(named: "Econom")
        economImg?.isHidden = product.isLowCost ? false : true
        economBig?.isHidden = product.isLowCost ? false : true
        
        // set rating value
        if product.rating == 0 {
            ratingLbl.isHidden = true
        } else {
            ratingLbl.rating = Double(product.rating)
            ratingLbl.isHidden = false
        }
        
        // set image view
        thumbnailImg?.layer.cornerRadius = thumbnailImg.frame.height/10
        thumbnailImg?.layer.borderWidth = 1.0
        thumbnailImg?.layer.borderColor = (UIColor.CustomColors.yellow).cgColor
        thumbnailImg?.clipsToBounds = true

    }


    // MARK: - Actions

}
