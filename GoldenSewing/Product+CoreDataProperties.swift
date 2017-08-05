//
//  Product+CoreDataProperties.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 03.08.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var subName: String?
    @NSManaged public var inlay: NSArray?
    @NSManaged public var methodVal: NSArray?
    @NSManaged public var isLowCost: Bool
    @NSManaged public var featuredImg: NSData?
    @NSManaged public var cloth: NSArray?
    @NSManaged public var category: ProductCategory?

}
