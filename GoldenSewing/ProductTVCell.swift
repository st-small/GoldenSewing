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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ product: Product) {
        
        nameLabel.text = product.name?.capitalized
        articleLabel.text = "\(product.id)"
        typeLabel.text = product.subName?.capitalized
        let data = product.featuredImg! as Data
        imgView?.image = UIImage(data: data)
        
        imgView?.layer.cornerRadius = imgView.frame.height/10
        imgView?.clipsToBounds = true
        
    }

}
