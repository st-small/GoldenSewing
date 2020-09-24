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
    
    // Data
    private var defaultImage: UIImage {
        return #imageLiteral(resourceName: "Placeholder")
    }
    private var thumbSize: Float {
        switch UIScreen.main.bounds.width {
        case 320.0, 375.0:
            return 60.0
        case 414.0:
            return 175.0
        default:
            return 60.0
        }
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
        guard let url = url else { return }
        let urlValue = URL(string: url)
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.sd_setImage(with: urlValue) { [weak self] (image, _, _, _) in
            guard let this = self else { return }
            guard
                let image = image,
                let data = this.resize(image: image, maxHeight: this.thumbSize, maxWidth: this.thumbSize, compressionQuality: 1.0) else { return }
            this.image = UIImage(data: data)
        }
    }
}

// MARK: - Image methods
extension CachedImage {
    
    public func setupImage(id: Int, url: String?) {
        guard let url = url, !url.isEmpty else { return }
        let urlValue = URL(string: url)
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.sd_setImage(with: urlValue) { [weak self] (image, _, _, _) in
            guard let this = self else { return }
            guard
                let image = image else { return }
            this.image = image
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
