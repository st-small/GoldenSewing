//
//  PersistentService.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 31.07.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import CoreData

let BASE_URL = "http://zolotoe-shitvo.kr.ua/wp-json/wp/v2/"
let B_URL = "http://zolotoe-shitvo.kr.ua/wp-json/wp/v2/posts?categories="//&per_page=100"
var pCount = 0

class PersistentService {
    
    // MARK: - Persistent Functionality -
    // check categories and fetch all titles
    static func getProductCategories(callback: @escaping ([ProductCategory])->()) {
        // let try to get productCategories from DB
        let prCat = ProductCategory.getPRCategories()
        if !prCat.isEmpty {
            print("Func PersistentService 'getProductCategories' -> There are \(prCat.count) prCategories in DB")
            callback(prCat)
            getListOfCategories(callback: { (prCat: [ProductCategory]) -> () in
                
            })
        } else {
            getListOfCategories(callback: { (prCat: [ProductCategory]) -> () in
                callback(prCat)
            })
        }
    }
    
    static func getProductCategoryBy(ID: Int, callback: @escaping (ProductCategory)->()) {
        // let try to get productCategory from DB
        let prCat = ProductCategory.getPRCategoryBy(ID: ID, context: CoreDataStack.instance.persistentContainer.viewContext)
        if prCat != nil {
            print("Func PersistentService 'getProductCategoryByID' -> There are \(prCat?.name) prCategories in DB")
            callback(prCat!)
            getProductCategoryBy(ID: ID, callback: { (prCat: ProductCategory) -> () in
                callback(prCat)
            })
        } else {
            getProductCategoryBy(ID: ID, callback: { (prCat: ProductCategory) -> () in
                callback(prCat)
            })
        }
    }
    /*
    static func getProductsByParent(categoryID: Int, callback: @escaping ([Product])->()) {
        // let try to get products from DB
        let pr = Product.getProductByParentCategory(productCatID: categoryID)
        if !pr.isEmpty {
            print("Func PersistentService 'getProducts' -> There are \(pr.count) products in DB")
            callback(pr)
            getAllPostsInCategory(categoryID, callback: { (pr: [Product]) -> () in
            })
        } else {
            getAllPostsInCategory(categoryID, callback: { (pr: [Product]) -> () in
                callback(pr)
            })
        }
    }*/
    
    // MARK: - API Functionality -
    // get category by id (http://zolotoe-shitvo.kr.ua/wp-json/wp/v2/categories/3)
    private static func getProductCategoryBy(ID: Int, callback:@escaping ()->()) {
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: "\(BASE_URL)"+"categories/\(ID)")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            // Получение количества всех записей в данной категории
            if let response = response as? HTTPURLResponse {
                print(response)

            }
            if error != nil {
                print(error!.localizedDescription)
            }
            callback()
        })
        task.resume()
    }

    
    // get all categories from site (http://zolotoe-shitvo.kr.ua/wp-json/wp/v2/categories/)
    private static func getPostsCount(urlString: String, callback:@escaping (Int)->()) {
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: "\(BASE_URL)"+"\(urlString)")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            // Получение количества всех записей в данной категории
            if let response = response as? HTTPURLResponse {
                print(response)
                
                if let postsCount = response.allHeaderFields["X-WP-Total"] as? String {
                    print(postsCount)
                    let postCountInt = Int(postsCount)
                    //pCount = Int(postsCount)!
                    callback(postCountInt!)
                }
            }
            if error != nil {
                print(error!.localizedDescription)
            }
            //callback(postsCount)
        })
        task.resume()
    }
    
    private static func getListOfCategories(callback: @escaping ([ProductCategory])->()) {
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        
        let url = URL(string: "\(BASE_URL)"+"categories?page=1&per_page=50")!
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [Dictionary<String, AnyObject>] {
                        var prCats = [ProductCategory]()
                        let moc = CoreDataStack.instance.persistentContainer.viewContext
                        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                        privateMOC.parent = moc
                        for value in json {
                            if let id = value["id"] as? Int {
                                //print("Func 'getListOfCategories' -> print id value \(id)")
                                if !ProductCategory.isInDBBy(ID: id) {
                                    let category = ProductCategory(context: moc)
                                    category.id = Int16(id)
                                    if let title = value["name"] as? String {
                                        //print("Func 'getListOfCategories' -> print title value \(title)")
                                        category.name = title
                                    }
                                    
                                    // get the count of posts in category 
                                    getPostsCount(urlString: "posts?categories=\(id)", callback: { (postsCount) in
                                        category.postsCount = Int16(postsCount)
                                        prCats.append(category)
                                        try? privateMOC.saveWithParent()
                                        //CoreDataStack.instance.saveContext()
                                        callback(prCats)
                                        
                                    })
                                    
                                }
                            }
                        }
                        //print("Func 'getListOfCategories' -> print json \(json)")
                    }
                } catch {
                    print("error in JSONSerialization")
                }
            }
        })
        task.resume()
    }
    /*
    private static func getAllPostsInCategory(_ categoryID: Int, callback: @escaping ([Product])->()) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let str = "posts?categories=\(categoryID)"
        let url = URL(string: "\(BASE_URL)"+"\(str)")!
        
        getPostsCount(urlString: str) {
            for i in stride(from: 0, through: pCount, by: 10) {
                print("i = \(i)")
                let url = URL(string: "\(url)"+"&offset=\(i)")!
                let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
                    
                    if error != nil {
                        
                        print(error!.localizedDescription)
                        
                    } else {
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [Dictionary<String, AnyObject>] {
                                var products = [Product]()
                                let moc = CoreDataStack.instance.persistentContainer.viewContext
                                let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                                privateMOC.parent = moc

                                //let moc = CoreDataStack.instance.persistentContainer.viewContext
                                    for value in json {
                                        
                                        if let id = value["id"] as? Int {
                                            //print(id)
                                            if !Product.isInDBBy(ID: id) {
                                                let product = Product(context: privateMOC)
                                                let category = ProductCategory.getPRCategoryBy(ID: categoryID, context: privateMOC)
                                                product.category = category
                                                product.id = Int16(id)
                                                
                                                // get name
                                                if let titleDict = value["title"] as? Dictionary<String, String> {
                                                    if let title = titleDict["rendered"] {
                                                        //print(title)
                                                        product.name = title
                                                        
                                                    }
                                                }
                                                
                                                // get cloth
                                                if let acf = value["acf"] as? Dictionary<String, AnyObject> {
                                                    let attributes = acf["attributes"] as! NSArray
                                                    if attributes.count > 0 {
                                                        
                                                        if let clothDict = attributes[0] as? Dictionary<String, AnyObject> {
                                                            if let clothArr = clothDict["default_value_cloth"] as? NSArray {
                                                                var arr = [String]()
                                                                for val in clothArr {
                                                                    if let cloth = Constants.clothDict["\(val)"] {
                                                                        //print("cloth is \(cloth)")
                                                                        arr.append(cloth)
                                                                    }
                                                                }
                                                                product.cloth = arr as NSArray
                                                            }
                                                        }
                                                        
                                                        if let productMethod = attributes[1] as? Dictionary<String, AnyObject> {
                                                            if let method = productMethod["default_value_product"] as? NSArray {
                                                                var arr2 = [String]()
                                                                for val in method {
                                                                    if let methodVal = Constants.methodValDict["\(val)"] {
                                                                        //print("method is \(methodVal)")
                                                                        
                                                                        arr2.append(methodVal)
                                                                    }
                                                                }
                                                                product.subName = arr2.contains(Constants.methodValDict["product_6"]!) ? Constants.methodValDict["product_6"]! : Constants.methodValDict["product_9"]!
                                                                product.methodVal = arr2 as NSArray
                                                            }
                                                        }
                                                        
                                                        if let inlay = attributes[2] as? Dictionary<String, AnyObject> {
                                                            if let inlayArr = inlay["default_value_inlay"] as? NSArray {
                                                                var arr3 = [String]()
                                                                for val in inlayArr {
                                                                    if let inlayVal = Constants.inlayDict["\(val)"] {
                                                                        //print("method is \(inlayVal)")
                                                                        
                                                                        arr3.append(inlayVal)
                                                                    }
                                                                }
                                                                product.inlay = arr3 as NSArray
                                                            }
                                                        }
                                                    }
                                                    
                                                    if let lowCost = acf["best_offer"] {
                                                        product.isLowCost = lowCost as! Bool == true ? true : false
                                                        print(lowCost)
                                                    }
                                                }
                                                
                                                // get featured image for product
                                                if let featuredImg = value["better_featured_image"] as? Dictionary<String, AnyObject> {
                                                    if let imgLink = featuredImg["source_url"] as? String {
                                                        //print(imgLink)
                                                        let data = try? Data(contentsOf: URL(string: imgLink)!)
                                                        product.featuredImg = data! as NSData
                                                    }
                                                }
                                                
                                                products.append(product)
                                                try? privateMOC.saveWithParent()
                                                callback(products)
                                            }
                                        }
                                    }
                                    
                                //print(json)
                                
                            }
                        } catch {
                            print("error in JSONSerialization")
                        }
                    }
                })
                task.resume()
            }
        }
    }
        
    */
    
}
