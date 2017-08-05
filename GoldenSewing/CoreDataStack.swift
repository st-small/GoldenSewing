//
//  CoreDataStack.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 01.08.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    // Singleton
    static let instance = CoreDataStack()
    private init() {}
    
    // MARK: - Core Data stack
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "Model", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension CoreDataStack {
    
    func getAllDataFromDB() {
        var array = [ProductCategory]()
        let context = self.persistentContainer.viewContext
        let request: NSFetchRequest<ProductCategory> = ProductCategory.fetchRequest()
        
        do {
            array = try context.fetch(request)
            if array.isEmpty {
                print("Func 'CoreDataStack getAllDataFromDB' -> данных нет!")
            } else {
                print("Func 'CoreDataStack getAllDataFromDB' -> в кордате аж \(array.count) записей!!!")
            }
        } catch let error as NSError {
            print(error.userInfo)
        }
    }
    
    func deleteAllInstancesOf(entity: String, context: NSManagedObjectContext) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("There was an error")
        }
    }
}

extension NSManagedObjectContext {
    
    func saveWithParent() throws {
        do {
            try self.save()
            if let parentMOC = self.parent {
                parentMOC.performAndWait {
                    do {
                        try parentMOC.save()
                    } catch {
                        print("Can't save parent context \(error.localizedDescription)")
                    }
                }
            }
        }
        catch {
            print("Can't save current context \(error.localizedDescription)")
            throw error
        }
    }
}

