//
//  ImageContainerModel.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 4/15/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import Gloss

public class ImageContainerModel: Glossy {
    
    public var id = 0
    public var thumbnailLink: String?
    public var thumbnailData: Data?
    
    public var imageLink: String?
    public var imageData: Data?
    
    public required init(id: Int, thumb: String? = nil, image: String? = nil) {
        self.id = id
        self.thumbnailLink = thumb
        self.imageLink = image
    }
    
    public init(item: ImageContainerModelRealmItem?) {
        
        guard let item = item else { return }
        self.id = item.id
        self.thumbnailLink = item.thumbnailLink
        self.thumbnailData = item.thumbnailData
        self.imageLink = item.imageLink
        self.imageData = item.imageData
    }
    
    public required init?(json: JSON) {
        
    }
    
    public func toJSON() -> JSON? {
        return nil
    }
    
    public struct Keys {
        
        public static let id = "id"
        public static let count = "count"
        
        public static let title = "name"
        public static let link = "link"
    }
}

public class ImageContainerModelRealmItem: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var thumbnailLink: String? = nil
    @objc dynamic var thumbnailData: Data? = nil
    
    @objc dynamic var imageLink: String? = nil
    @objc dynamic var imageData: Data? = nil
    
    public convenience init(item: ImageContainerModel?) {
        self.init()
        
        guard let item = item else { return }
        self.id = item.id
        self.thumbnailLink = item.thumbnailLink
        self.thumbnailData = item.thumbnailData
        self.imageLink = item.imageLink
        self.imageData = item.imageData
    }
}
