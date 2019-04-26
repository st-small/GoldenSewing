//
//  OtherProductModel.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 4/16/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import Gloss
import SwiftSoup

public class OtherProductModel: Glossy {
    
    public var id = 0
    public var title = ""
    public var modified: Double = 0
    public var imageContainers = [ImageContainerModel]()
    
    public init() {
        self.id = 0
        self.title = ""
    }
    
    public init(item: OtherProductModelRealmItem) {
        self.id = item.id
        self.title = item.title
        self.modified = item.modified
        
        for model in item.imageContainers {
            let container = ImageContainerModel(item: model)
            self.imageContainers.append(container)
        }
    }
    
    public required init?(json: JSON) {
        
        // id
        let id: Int = (Keys.id <~~ json)!
        self.id = id == 1122 ? 18 : 1
        
        // title
        let titleDict: [String: Any] = (Keys.title <~~ json)!
        let title: String = (Keys.rendered <~~ titleDict)!
        self.title = title.html2AttributedString?.string ?? ""
        
        // modified
        let modifiedDateString: String = (Keys.modified <~~ json)!
        let modifiedDate = modifiedDateString.toDate()
        self.modified = modifiedDate.timeIntervalSince1970
        
        // images
        let imagesDict: [String: Any] = (Keys.content <~~ json)!
        let images: String = (Keys.rendered <~~ imagesDict)!
        
        var indexId = id + 10999
        do {
            let els: Elements = try SwiftSoup.parse(images).select("a")
            for link: Element in els.array() {
                let linkHref: String = try link.attr("href")
                
                let container = ImageContainerModel(id: indexId, image: linkHref)
                self.imageContainers.append(container)
                indexId += 1
            }
        } catch Exception.Error(_, let message) {
            print(message)
        } catch {
            print("error")
        }
    }
    
    public func toJSON() -> JSON? {
        return nil
    }
    
    public struct Keys {
        public static let id = "id"
        public static let title = "title"
        public static let modified = "modified_gmt"
        public static let rendered = "rendered"
        public static let content = "content"
    }
}

public class OtherProductModelRealmItem: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var modified: Double = 0
    var imageContainers = List<ImageContainerModelRealmItem>()
    
    public convenience init(item: OtherProductModel) {
        self.init()
        
        self.id = item.id
        self.title = item.title
        self.modified = item.modified
        
        item.imageContainers.forEach { model in
            let container = ImageContainerModelRealmItem(item: model)
            self.imageContainers.append(container)
        }
    }
}
