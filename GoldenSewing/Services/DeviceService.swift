//
//  DeviceService.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 5/18/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import RealmSwift

public class DeviceService {
    
    public static let shared = DeviceService()
    public var launchIndex: Int = 0
    
    // Services
    private var properties = UserDefaults.standard
    private let realm = try! Realm()
    private weak var productsService = ProductsCacheService.shared
    
    public func start() {
        launchIndex = properties.integer(forKey: "launchIndex")
        findEmptyCategory()
        migration()
    }
    
    public func updateLaunchValue() {
        launchIndex += 1
        properties.set(launchIndex, forKey: "launchIndex")
    }
    
    private func findEmptyCategory() {
        guard launchIndex != 0 else { return }
        let categories = realm.objects(CategoryModelRealmItem.self)
        let categoryIds = categories.map({ $0.id })
        for id in categoryIds {
            let values = realm.objects(ProductModelRealmItem.self).filter({ $0.category == id })
            if values.isEmpty {
                productsService?.load(id: id)
                productsService?.all()
                break
            }
        }
    }
    
    private func migration() {
        guard
            let version = UIApplication.appVersion else { return }
        let stringValue = version.replacingOccurrences(of: ".", with: "")
        let intValue = Int(stringValue) ?? 0
        if intValue <= 201 {
            try! realm.write {
                realm.deleteAll()
            }
        }
    }
}

extension UIApplication {
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}
