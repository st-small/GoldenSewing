//
//  ProductModel.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 3/30/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import Gloss

public class ProductModel: Glossy {
    
    public var id = 0
    public var title = ""
    public var timestamp: Double = 0
    
    public var category = 0
    public var modified: Double = 0
    
    public var imageLink = ""
    public var imageData: Data?
    
    public var imageContainer: ImageContainerModel?
    
    public var bestOffer = false
    
    public init() {
        self.id = 0
        self.title = ""
    }
    
    public init(item: ProductModelRealmItem) {
        self.id = item.id
        self.title = item.title
        self.timestamp = item.timestamp
        
        self.category = item.category
        self.modified = item.modified
        
        self.imageLink = item.imageLink
        self.imageData = item.imageData
        
        self.imageContainer = ImageContainerModel(item: item.imageContainer)
        
        self.bestOffer = item.bestOffer
    }
    
    public required init?(json: JSON) {
        self.id = (Keys.id <~~ json)!
        
        // title
        let titleDict: [String: Any] = (Keys.title <~~ json)!
        let title: String = (Keys.rendered <~~ titleDict)!
        self.title = title.html2AttributedString?.string ?? ""
        
        self.timestamp = Date().timeIntervalSince1970
        
        let categories: [Int] = (Keys.categories <~~ json)!
        self.category = categories.first ?? 0
        
        let modifiedDateString: String = (Keys.modified <~~ json)!
        let modifiedDate = modifiedDateString.toDate()
        self.modified = modifiedDate.timeIntervalSince1970
        
        // image
        let media: [String: Any] = (Keys.better_featured_image <~~ json)!
        let mediaDetails: [String: Any] = (Keys.media_details <~~ media)!
        let sizes: [String: Any] = (Keys.sizes <~~ mediaDetails)!
        let thumbnail: [String: Any] = (Keys.thumbnail <~~ sizes)!
        let sourceUrl: String = (Keys.source_url <~~ thumbnail)!
        self.imageContainer = ImageContainerModel(id: id, thumb: sourceUrl)
        let imageLink: String = (Keys.source_url <~~ media)!
        self.imageContainer?.imageLink = imageLink
        
        // tags
        let acf: [String: Any] = (Keys.acf <~~ json)!
        self.bestOffer = (Keys.best_offer <~~ acf)!
    }
    
    public func toJSON() -> JSON? {
        return nil
    }
    
    public struct Keys {
        
        public static let id = "id"
        public static let title = "title"
        public static let rendered = "rendered"
        public static let categories = "categories"
        
        public static let modified = "modified_gmt"
        
        // image
        public static let better_featured_image = "better_featured_image"
        public static let media_details = "media_details"
        public static let sizes = "sizes"
        public static let thumbnail = "thumbnail"
        public static let source_url = "source_url"
        
        // tags
        public static let acf = "acf"
        public static let best_offer = "best_offer"
    }
}

public class ProductModelRealmItem: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var timestamp: Double = 0
    
    @objc dynamic var category = 0
    @objc dynamic var modified: Double = 0
    
    @objc dynamic var imageLink = ""
    @objc dynamic var imageData: Data? = nil
    
    @objc dynamic var imageContainer: ImageContainerModelRealmItem? = nil
    
    @objc dynamic var bestOffer = false
    
    public convenience init(item: ProductModel) {
        self.init()
        
        self.id = item.id
        self.title = item.title
        self.timestamp = item.timestamp
        
        self.category = item.category
        self.modified = item.modified
        
        self.imageLink = item.imageLink
        self.imageData = item.imageData
        
        self.imageContainer = ImageContainerModelRealmItem(item: item.imageContainer)
        
        self.bestOffer = item.bestOffer
    }
}
