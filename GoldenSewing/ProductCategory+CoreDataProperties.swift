//
//  ProductCategory+CoreDataProperties.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 14.08.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import CoreData


extension ProductCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductCategory> {
        return NSFetchRequest<ProductCategory>(entityName: "ProductCategory")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var postsCount: Int16
    @NSManaged public var lastUpdate: NSDate?
    @NSManaged public var products: NSSet?

}

// MARK: Generated accessors for products
extension ProductCategory {

    @objc(addProductsObject:)
    @NSManaged public func addToProducts(_ value: Product)

    @objc(removeProductsObject:)
    @NSManaged public func removeFromProducts(_ value: Product)

    @objc(addProducts:)
    @NSManaged public func addToProducts(_ values: NSSet)

    @objc(removeProducts:)
    @NSManaged public func removeFromProducts(_ values: NSSet)

}
