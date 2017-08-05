//
//  Product+CoreDataClass.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 03.08.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import CoreData

@objc(Product)
public class Product: NSManagedObject {
    
    internal static func isInDBBy(ID: Int) -> Bool {
        let context = CoreDataStack.instance.persistentContainer.viewContext
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", ID)
        
        do {
            let products = try context.fetch(request)
//            for product in products {
//                //print(product.name ?? "no name")
//                //print(product.id )
//            }
            return !(products.isEmpty)
        } catch {
            fatalError("Cannot get trip info")
        }
    }

    internal static func getProductByParentCategory(productCatID: Int) -> [Product] {
        let context = CoreDataStack.instance.persistentContainer.viewContext
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        request.predicate = NSPredicate(format: "category.id == %d", productCatID)
        
        do {
            let results = try context.fetch(request)
            
//            for product in results {
//                print("id - \(product.id)\nname - \(product.name!)\nsubname - \(product.subName)\ncloth - \(product.cloth?.count)\nmethod - \(product.methodVal?.count)")
//                print("****************************")
//                for val in product.methodVal! {
//                    print(val)
//                }
//            }
            
            return results
            
        } catch {
            fatalError("Func 'getProductByParentCategory' -> Cannot get products info")
        }
    }

}
