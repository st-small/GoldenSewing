//
//  UITableViewCell+Extension.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 08.08.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    
    func hideSeparator() {
        self.separatorInset = UIEdgeInsets(top: 0, left: self.bounds.size.width, bottom: 0, right: 0)
    }
    
    func showSeparator() {
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
