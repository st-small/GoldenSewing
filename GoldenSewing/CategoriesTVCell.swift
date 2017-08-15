//
//  CategoriesTVCell.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 02.08.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class CategoriesTVCell: UITableViewCell {

    @IBOutlet weak var btn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(_ title: String, tag: Int) {
        btn.tag = tag
        btn.titleLabel?.lineBreakMode = .byWordWrapping
        btn.titleLabel?.numberOfLines = 0
        btn.titleLabel?.textAlignment = .center
        if UIScreen.main.bounds.size.height < 600 {
            btn.titleLabel?.font = btn.titleLabel?.font.withSize(12)
        }
        btn.setTitle(title, for: .normal)
        self.hideSeparator()
    }
}
