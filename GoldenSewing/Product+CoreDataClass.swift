
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
//                print(product.name ?? "no name")
//                print(product.id )
//            }
//            print(products.isEmpty ? "no posts here" : "post is in DB")
            return !(products.isEmpty)
        } catch {
            fatalError("Cannot get trip info")
        }
    }
    
    

    internal static func getProductsByParentCategory(productCatID: Int) -> [Product] {
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
    
    internal static func findProductBy(categoryID: Int, ID: Int, orString string: String) -> [Product] {
        let context = CoreDataStack.instance.persistentContainer.viewContext
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        if categoryID == 0 {
            if ID == 0 {
                request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", string)
            } else {
                request.predicate = NSPredicate(format: "id CONTAINS[cd] %d AND NOT (category.id == 18) AND NOT (category.id == 1)", ID)
            }
        } else {
            if ID == 0 {
                request.predicate = NSPredicate(format: "category.id == %d AND name CONTAINS[cd] %@", categoryID, string)
            } else {
                request.predicate = NSPredicate(format: "category.id == %d AND id CONTAINS[cd] %d", categoryID, ID)
            }
        }
        
        
        do {
            let products = try context.fetch(request)
//            for product in products {
//                print(product.name ?? "no name")
//                print(product.id )
//                print(product.category?.id)
//            }
            
            return products
        } catch {
            fatalError("Cannot get trip info")
        }
    }
    
    internal static func findProductBy(_ ID: Int, category: Int) -> Product {
        let context = CoreDataStack.instance.persistentContainer.viewContext
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        request.predicate = NSPredicate(format: "id = %d AND category.id = %d", ID, category)

        do {
            let products = try context.fetch(request)
            return products.first!
        } catch {
            fatalError("Cannot get trip info")
        }
    }


}
