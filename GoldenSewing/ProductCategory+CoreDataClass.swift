//
//  ProductCategory+CoreDataClass.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 01.08.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import CoreData

@objc(ProductCategory)
public class ProductCategory: NSManagedObject {
    
    internal static func isInDBBy(ID: Int) -> Bool {
        let context = CoreDataStack.instance.persistentContainer.viewContext
        let request: NSFetchRequest<ProductCategory> = ProductCategory.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", ID)
        
        do {
            let prCats = try context.fetch(request)
//            for value in prCats {
//                print(value.name ?? "no name")
//            }
            return !(prCats.isEmpty)
        } catch {
            fatalError("Cannot get categories info")
        }
    }
    
    internal static func getPRCategoryBy(ID: Int, context: NSManagedObjectContext) -> ProductCategory? {
        let request: NSFetchRequest<ProductCategory> = ProductCategory.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", ID)
        do {
            let results = try context.fetch(request)
            if !results.isEmpty {
                return results.first!
            }
            
        } catch {
            fatalError("Func ProductCategory+CoreDataClass 'getPRCategoryBy' -> Cannot get prCategory info")
        }
        
        return nil
    }
    
    internal static func getPRCategories() -> [ProductCategory] {
        let context = CoreDataStack.instance.persistentContainer.viewContext
        let request: NSFetchRequest<ProductCategory> = ProductCategory.fetchRequest()
        
        do {
            let results = try context.fetch(request)
            return results
            
        } catch {
            fatalError("Func ProductCategory+CoreDataClass 'getPRCategories' -> Cannot get prCategories info")
        }
    }

}
