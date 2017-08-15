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

class PersistentService {
    
    // MARK: - Persistent Functionality -
    // check categories and fetch all titles
    static func getProductCategories(callback: @escaping ([ProductCategory], Int)->()) {
        // let try to get productCategories from DB
        let prCat = ProductCategory.getPRCategories()
        if !prCat.isEmpty {
            //print("Func PersistentService 'getProductCategories' -> There are \(prCat.count) prCategories in DB")
            if !prCat.isEmpty {
                callback(prCat, prCat.count)
            }
            getListOfCategories(callback: { (prCat: [ProductCategory], count: Int) -> () in
                callback(prCat, count)
            })
        } else {
            getListOfCategories(callback: { (prCat: [ProductCategory], count: Int) -> () in
                callback(prCat, count)
            })
        }
    }
    
    static func getProductCategoryBy(ID: Int, callback: @escaping (ProductCategory)->()) {
        // let try to get productCategory from DB
        let prCat = ProductCategory.getPRCategoryBy(ID: ID, context: CoreDataStack.instance.persistentContainer.viewContext)
        if prCat != nil {
            //print("Func PersistentService 'getProductCategoryByID' -> There are \(prCat?.name) prCategories in DB")
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
    
    // MARK: - API Functionality -
    // get category by id (http://zolotoe-shitvo.kr.ua/wp-json/wp/v2/categories/3)
    static func getAllProductCategoryBy(ID: Int, callback:@escaping ()->()) {
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: "\(BASE_URL)"+"categories/\(ID)")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            // Получение количества всех записей в данной категории
            //if let response = response as? HTTPURLResponse {
            //print(response)
            
            //}
            if error != nil {
                print(error!.localizedDescription)
            }
            callback()
        })
        task.resume()
    }
    
    // get posts count of every category kind
    private static func getPostsCount(urlString: String, callback:@escaping (Int)->()) {
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: "\(BASE_URL)"+"\(urlString)")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if let response = response as? HTTPURLResponse {
                //print(response)
                
                if let postsCount = response.allHeaderFields["X-WP-Total"] as? String {
                    //print(postsCount)
                    let postCountInt = Int(postsCount)
                    callback(postCountInt!)
                }
            }
            if error != nil {
                print(error!.localizedDescription)
            }
        })
        task.resume()
    }
    
    // get all categories from site (http://zolotoe-shitvo.kr.ua/wp-json/wp/v2/categories/)
    private static func getListOfCategories(callback: @escaping ([ProductCategory], Int)->()) {
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        
        let url = URL(string: "\(BASE_URL)"+"categories?page=1&per_page=50")!
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            // get value of max count categories
            var postsCountInt = 0
            if let response = response as? HTTPURLResponse {
                if let postsCount = response.allHeaderFields["X-WP-Total"] as? String {
                    postsCountInt = Int(postsCount)!
                }
            }
            
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
                                        callback(prCats, postsCountInt)
                                        
                                    })
                                    
                                }
                            }
                        }
                        
                        
                        // add geraldika category
                        if !ProductCategory.isInDBBy(ID: 18) {
                            let category = ProductCategory(context: moc)
                            category.id = 18
                            category.name = "Геральдика"
                            category.postsCount = 18
                            prCats.append(category)
                            try?moc.save()
                            
                            callback(prCats, postsCountInt)
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
    
    static func getServerAllPostsInCategory(_ categoryID: Int, withOffset offset: Int, callback: @escaping ([Product], Int)->()) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let str = "posts?categories=\(categoryID)"
        let url = URL(string: "\(BASE_URL)"+"\(str)")!
        let moc = CoreDataStack.instance.persistentContainer.viewContext
        let category = ProductCategory.getPRCategoryBy(ID: categoryID, context: moc)
        
        if offset < Int((category?.postsCount)!) || Int((category?.postsCount)!) == 0 {
            let url2 = URL(string: "\(url)"+"&offset=\(offset)")!
            let task = session.dataTask(with: url2, completionHandler: { (data, response, error) in
                var index = 0
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [Dictionary<String, AnyObject>] {
                            var products = [Product]()
                            let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                            privateMOC.parent = moc
                            for value in json {
                                //print("index value is \(index)")
                                index += 1
                                if let id = value["id"] as? Int {
                                    
                                    if !Product.isInDBBy(ID: id) {
                                        let product = Product(context: privateMOC)
                                        let category = ProductCategory.getPRCategoryBy(ID: categoryID, context: privateMOC)
                                        product.category = category
                                        product.id = Int16(id)
                                        
                                        // get name
                                        if let titleDict = value["title"] as? Dictionary<String, String> {
                                            if let title = titleDict["rendered"] {
                                                //print(title)
                                                var titleStr = title
                                                titleStr.replaceWrongCharacters()
                                                product.name = titleStr
                                            }
                                        }
                                        
                                        // get cloth
                                        if let acf = value["acf"] as? Dictionary<String, AnyObject> {
                                            let attributes = acf["attributes"] as! NSArray
                                            if attributes.count >= 1 {
                                                
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
                                            }
                                            
                                            if attributes.count >= 2 {
                                                
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
                                            }
                                            
                                            if attributes.count >= 3 {
                                                
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
                                                //print(lowCost)
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
                                        
                                        // get last modified date
                                        if let editedDate = value["modified"] as? String {
                                            //print("last modified \(editedDate)")
                                            //let date = editedDate.toDate()
                                            //let strDate = date.toString()
                                            //print("last modified after convert to date \(strDate)")
                                            product.edited = editedDate.toDate() as NSDate
                                        }
                                        
                                        products.append(product)
                                        try? privateMOC.saveWithParent()
                                        callback(products, Int(category!.postsCount))
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
            let postsFetch = offset + 10
            if Int((category?.postsCount)!) > postsFetch {
                getServerAllPostsInCategory(categoryID, withOffset: postsFetch, callback: { (product) in
                    
                })
            }
        }
    }
    
    static func getServerAllMetallonitPosts(withOffset offset: Int, callback: @escaping ([Product], Int)->()) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: "\(BASE_URL)"+"posts?categories=101")!
        let moc = CoreDataStack.instance.persistentContainer.viewContext
        let category = ProductCategory.getPRCategoryBy(ID: 101, context: moc)
        
        if offset < Int((category?.postsCount)!) || Int((category?.postsCount)!) == 0 {
            let url2 = URL(string: "\(url)"+"&offset=\(offset)")!
            let task = session.dataTask(with: url2, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [Dictionary<String, AnyObject>] {
                            var products = [Product]()
                            let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                            privateMOC.parent = moc
                            for value in json {
                                
                                if let id = value["id"] as? Int {
                                    
                                    if !Product.isInDBBy(ID: id) {
                                        let product = Product(context: privateMOC)
                                        let category = ProductCategory.getPRCategoryBy(ID: 101, context: privateMOC)
                                        product.category = category
                                        product.id = Int16(id)
                                        
                                        // get name
                                        if let titleDict = value["title"] as? Dictionary<String, String> {
                                            if let title = titleDict["rendered"] {
                                                //print(title)
                                                var titleStr = title
                                                titleStr.replaceWrongCharacters()
                                                product.name = titleStr
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
                                        
                                        // get last modified date
                                        if let editedDate = value["modified"] as? String {
                                            product.edited = editedDate.toDate() as NSDate
                                        }
                                        
                                        products.append(product)
                                        try? privateMOC.saveWithParent()
                                        callback(products, Int(category!.postsCount))
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
            let postsFetch = offset + 10
            if Int((category?.postsCount)!) > postsFetch {
                getServerAllMetallonitPosts(withOffset: postsFetch, callback: { (product) in
                    
                })
            }
        }
    }
    
    // get tkani category
    static func getServerAllPostsTkani(withOffset offset: Int, callback: @escaping ([Product], Int)->()) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: "\(BASE_URL)"+"posts?categories=103")!
        let moc = CoreDataStack.instance.persistentContainer.viewContext
        let category = ProductCategory.getPRCategoryBy(ID: 103, context: moc)
        
        if offset < Int((category?.postsCount)!) || Int((category?.postsCount)!) == 0 {
            let url2 = URL(string: "\(url)"+"&offset=\(offset)")!
            let task = session.dataTask(with: url2, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [Dictionary<String, AnyObject>] {
                            var products = [Product]()
                            let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                            privateMOC.parent = moc
                            for value in json {
                                if let id = value["id"] as? Int {
                                    
                                    if !Product.isInDBBy(ID: id) {
                                        let product = Product(context: privateMOC)
                                        let category = ProductCategory.getPRCategoryBy(ID: 103, context: privateMOC)
                                        product.category = category
                                        product.id = Int16(id)
                                        
                                        // get name
                                        if let titleDict = value["title"] as? Dictionary<String, String> {
                                            if let title = titleDict["rendered"] {
                                                //print(title)
                                                var titleStr = title
                                                titleStr.replaceWrongCharacters()
                                                product.name = titleStr
                                            }
                                        }
                                        
                                        if let acf = value["acf"] as? Dictionary<String, AnyObject> {
                                            let attributes = acf["attributes"] as! NSArray
                                            
                                            // get cloth
                                            if attributes.count >= 1 {
                                                
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
                                            }
                                            
                                            // get pattern
                                            if attributes.count >= 2 {
                                                
                                                if let patternDict = attributes[1] as? Dictionary<String, AnyObject> {
                                                    if let pNumber = patternDict["default_image"] as? String {
                                                        product.pattern = pNumber
                                                    }
                                                }
                                            }
                                            
                                            // get width
                                            if attributes.count >= 3 {
                                                
                                                if let widthDict = attributes[2] as? Dictionary<String, AnyObject> {
                                                    if let width = widthDict["default_width"] as? String {
                                                        product.width = width
                                                    }
                                                }
                                            }
                                            
                                            // get colors
                                            if attributes.count >= 4 {
                                                
                                                if let colorsDict = attributes[3] as? Dictionary<String, AnyObject> {
                                                    if let colorsArray = colorsDict["default_value_color"] as? NSArray {
                                                        var arr = [String]()
                                                        for val in colorsArray {
                                                            if let color = Constants.colorValDict["\(val)"] {
                                                                //print("color is \(color)")
                                                                arr.append(color)
                                                            }
                                                        }
                                                        product.color = arr as NSArray
                                                    }
                                                }
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
                                        
                                        // get last modified date
                                        if let editedDate = value["modified"] as? String {
                                            //print("last modified \(editedDate)")
                                            //let date = editedDate.toDate()
                                            //let strDate = date.toString()
                                            //print("last modified after convert to date \(strDate)")
                                            product.edited = editedDate.toDate() as NSDate
                                        }
                                        
                                        products.append(product)
                                        try? privateMOC.saveWithParent()
                                        callback(products, Int((category?.postsCount)!))
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
//            let postsFetch = offset + 10
//            if Int((category?.postsCount)!) > postsFetch {
//                getServerAllPostsTkani(withOffset: postsFetch, callback: { (product) in
//                    
//                })
//            }
        }
    }
    
    // get raznoe category
    static func getServerAllPostsFromPage(categoryID: Int, callback: @escaping ([Product], Int)->()) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let page = (categoryID == 1 ? 1148 : 1122)
        let url = URL(string: "\(BASE_URL)"+"pages/\(page)")!
        let moc = CoreDataStack.instance.persistentContainer.viewContext
        
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? Dictionary<String, AnyObject> {
                        var imagesArray = [String]()
                        var products = [Product]()
                        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                        privateMOC.parent = moc
                        let category = ProductCategory.getPRCategoryBy(ID: categoryID, context: privateMOC)
                        
                        // get all products raznoe from DB
                        let productsInDB = Product.getProductsByParentCategory(productCatID: categoryID)
                        if Int((category?.postsCount)!) > productsInDB.count {
                            
                            // get all images links and put them in array
                            if let content = json["content"] as? Dictionary<String, AnyObject> {
                                if let rendered = content["rendered"] as? String {
                                    var stringsArray = rendered.components(separatedBy: " href='")
                                    stringsArray.remove(at: 0)
                                    for val in stringsArray {
                                        let stringsArray2 = val.components(separatedBy: "'><img width=\"150\" ")
                                        imagesArray.append(stringsArray2[0])
                                    }
                                }
                            }
                            // get data images from server
                            for (index, value) in imagesArray.enumerated() {
                                let product = Product(context: privateMOC)
                                
                                product.category = category
                                product.id = Int16(index+1)
                                let data = try? Data(contentsOf: URL(string: value)!)
                                product.featuredImg = data! as NSData
                                
                                products.append(product)
                            }
                            
                            try? privateMOC.saveWithParent()
                            callback(products, Int((category?.postsCount)!))
                        }
                    }
                } catch {
                    print("error in JSONSerialization")
                }
            }
        })
        task.resume()
    }
    
    static func getServerPostBy(_ postID: Int, callback:@escaping ()->()) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let str = "posts/\(postID)"
        let url = URL(string: "\(BASE_URL)"+"\(str)")!
        let moc = CoreDataStack.instance.persistentContainer.viewContext
        let post = Product.findProductBy(postID)
        
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? Dictionary<String, AnyObject> {
                        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                        privateMOC.parent = moc
                        
                        print("\(post.name!) -> \(post.id)")
                        
                        // get last modified date
                        if let editedDate = json["modified"] as? String {
                            //print("last modified \(editedDate) and post last mofified is \(post?.edited)")
                            let date = editedDate.toDate() as NSDate
                            
                            if date != post.edited {
                                //print("The post with id \(post.id) and title \(post.name) modified date \(post.edited) is changed to \(date)")
                                
                                post.edited = date
                                
                                // get name
                                if let titleDict = json["title"] as? Dictionary<String, String> {
                                    if let title = titleDict["rendered"] {
                                        //print(title)
                                        var titleStr = title
                                        titleStr.replaceWrongCharacters()
                                        post.name = titleStr
                                    }
                                }
                                
                                // get cloth
                                if let acf = json["acf"] as? Dictionary<String, AnyObject> {
                                    let attributes = acf["attributes"] as! NSArray
                                    
                                    if attributes.count >= 1 {
                                        if let clothDict = attributes[0] as? Dictionary<String, AnyObject> {
                                            if let clothArr = clothDict["default_value_cloth"] as? NSArray {
                                                var arr = [String]()
                                                for val in clothArr {
                                                    if let cloth = Constants.clothDict["\(val)"] {
                                                        arr.append(cloth)
                                                    }
                                                }
                                                post.cloth = arr as NSArray
                                            }
                                        }
                                    }
                                    
                                    if attributes.count >= 2 {
                                        
                                        if let productMethod = attributes[1] as? Dictionary<String, AnyObject> {
                                            if let method = productMethod["default_value_product"] as? NSArray {
                                                var arr2 = [String]()
                                                for val in method {
                                                    if let methodVal = Constants.methodValDict["\(val)"] {
                                                        //print("method is \(methodVal)")
                                                        
                                                        arr2.append(methodVal)
                                                    }
                                                }
                                                post.subName = arr2.contains(Constants.methodValDict["product_6"]!) ? Constants.methodValDict["product_6"]! : Constants.methodValDict["product_9"]!
                                                post.methodVal = arr2 as NSArray
                                            }
                                        }
                                    }
                                    
                                    if attributes.count >= 3 {
                                        
                                        if let inlay = attributes[2] as? Dictionary<String, AnyObject> {
                                            if let inlayArr = inlay["default_value_inlay"] as? NSArray {
                                                var arr3 = [String]()
                                                for val in inlayArr {
                                                    if let inlayVal = Constants.inlayDict["\(val)"] {
                                                        arr3.append(inlayVal)
                                                    }
                                                }
                                                post.inlay = arr3 as NSArray
                                            }
                                        }
                                    }
                                    
                                    if let lowCost = acf["best_offer"] {
                                        post.isLowCost = lowCost as! Bool == true ? true : false
                                    }
                                }
                                
                                // get featured image for product
                                if let featuredImg = json["better_featured_image"] as? Dictionary<String, AnyObject> {
                                    if let imgLink = featuredImg["source_url"] as? String {
                                        //print(imgLink)
                                        let data = try? Data(contentsOf: URL(string: imgLink)!)
                                        post.featuredImg = data! as NSData
                                    }
                                }
                                
                                try? privateMOC.saveWithParent()
                            }
                        }
                    }
                    
                    callback()
                    //print(json)
                } catch {
                    print("error in JSONSerialization")
                }
            }
        })
        task.resume()
    }
}
