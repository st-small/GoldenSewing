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
    
    func configureCell(_ image: String, _ title: String, _ article: String, _ type: String) {
        
        nameLabel.text = title.capitalized
        articleLabel.text = article
        typeLabel.text = type
        imgView?.image = UIImage(named: "\(image)")
        
        imgView?.layer.cornerRadius = imgView.frame.height/10
        imgView?.clipsToBounds = true
        
    }

}
