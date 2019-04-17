//
//  CategoriesCell.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 11/24/18.
//  Copyright © 2018 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

public protocol CategoriesCellDelegate {
    func didSelectCategory(with id: Int)
}

public class CategoriesCell: UITableViewCell {
    
    // UI elements
    @IBOutlet private weak var action: UIButton! 
    
    private let colors = UIColor.CustomColors.self
    
    public static let identifier = "CategoriesCell"
    private static let nibName = "CategoriesCell"
    
    private var category: CategoryModel!
    private var delegate: CategoriesCellDelegate!
    
    public static func register(in table: UITableView) {
        
        let nib = UINib.init(nibName: nibName, bundle: Bundle.main)
        table.register(nib, forCellReuseIdentifier: identifier)
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        
        action.setTitleColor(colors.yellow, for: .normal)
        action.titleLabel?.textAlignment = .center
    }
    
    public func update(category: CategoryModel, with delegate: CategoriesCellDelegate) {
        
        self.category = category
        self.delegate = delegate
        
        action.setTitle(category.title, for: .normal)
        
    }
    
    @IBAction private func categoryTapped(_ sender: UIButton) {
        guard let delegate = delegate, let category = category else { return }
        delegate.didSelectCategory(with: category.id)
    }
}
