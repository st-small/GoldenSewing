//
//  CategoryModel.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 11/24/18.
//  Copyright © 2018 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import RealmSwift

public class CategoryModel {
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var count = 0
    @objc dynamic var link = ""
    @objc dynamic var timestamp = 0
    @objc dynamic var needUpdate = false
}
