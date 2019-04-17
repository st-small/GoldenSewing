//
//  CachedImage.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 4/14/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit
import SDWebImage
import RealmSwift

public class CachedImage: UIImageView {
    
    // Services
    private let realm = try! Realm()
    
    // Data
    private var defaultImage: UIImage {
        return #imageLiteral(resourceName: "Placeholder")
    }
    private var thumbSize: Float {
        return 60.0
    }
    private var imageSize: Float {
        return Float(UIScreen.main.bounds.width)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    public required init(coder: NSCoder) {
        super.init(coder: coder)!
        
        initialize()
    }
    
    private func initialize() {
        
        self.contentMode = .scaleAspectFill
        self.backgroundColor = UIColor.white
        
        self.image = defaultImage
    }
    
    public func clear() {
        self.image = defaultImage
    }
}

// MARK: - Thumb methods
extension CachedImage {
    
    public func setupThumb(id: Int, url: String?) {
        // Проверить, если для этого продукта в базе есть картинка, то показать, если нет, то грузить по сети
        guard let url = url else { return }
        if let image = getThumbImageFromDB(id: id) {
            self.image = image
        } else {
            let urlValue = URL(string: url)
            self.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.sd_setImage(with: urlValue) { [weak self] (image, _, _, _) in
                guard let this = self else { return }
                guard
                    let image = image,
                    let data = this.resize(image: image, maxHeight: this.thumbSize, maxWidth: this.thumbSize, compressionQuality: 1.0) else { return }
                this.saveThumbImageToDB(id: id, data: data)
            }
        }
    }
    
    private func getThumbImageFromDB(id: Int) -> UIImage? {
        guard
            let currentContainer = realm.objects(ImageContainerModelRealmItem.self).filter({ $0.id == id }).first,
            let imageData = currentContainer.thumbnailData else { return nil }
        
        guard let uiImage: UIImage = UIImage(data: imageData) else { return nil }
        return uiImage
    }
    
    private func saveThumbImageToDB(id: Int, data: Data?) {
        guard
            let data = data,
            let currentImage = realm.objects(ImageContainerModelRealmItem.self).filter({ $0.id == id }).first else { return }
        try! self.realm.write {
            currentImage.thumbnailData = data
        }
    }
}

// MARK: - Image methods
extension CachedImage {
    
    public func setupImage(id: Int, url: String?) {
        guard let url = url, !url.isEmpty else { return }
        if let image = getImageFromDB(id: id) {
            self.image = image
        } else {
            let urlValue = URL(string: url)
            self.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.sd_setImage(with: urlValue) { [weak self] (image, _, _, _) in
                guard let this = self else { return }
                guard
                    let image = image,
                    let data = image.pngData() else { return }
                this.saveImageToDB(id: id, data: data)
            }
        }
    }
    
    private func getImageFromDB(id: Int) -> UIImage? {
        guard let currentContainer = realm.objects(ImageContainerModelRealmItem.self).filter({ $0.id == id }).first, let imageData = currentContainer.imageData else { return nil }
        
        guard let uiImage: UIImage = UIImage(data: imageData) else { return nil }
        return uiImage
    }
    
    private func saveImageToDB(id: Int, data: Data?) {
        guard
            let data = data,
            let currentImage = realm.objects(ImageContainerModelRealmItem.self).filter({ $0.id == id }).first else { return }
        try! self.realm.write {
            currentImage.imageData = data
        }
    }
}

// MARK: - Helper methods
extension CachedImage {
    private func resize(image: UIImage, maxHeight: Float = 500.0, maxWidth: Float = 500.0, compressionQuality: Float = 0.5) -> Data? {
        var actualHeight: Float = Float(image.size.height)
        var actualWidth: Float = Float(image.size.width)
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in:rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = img!.jpegData(compressionQuality: CGFloat(compressionQuality))
        UIGraphicsEndImageContext()
        return imageData
    }
}
