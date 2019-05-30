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
        updateLaunchValue()
        findEmptyCategory()
    }
    
    private func updateLaunchValue() {
        launchIndex = properties.integer(forKey: "launchIndex")
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
}
