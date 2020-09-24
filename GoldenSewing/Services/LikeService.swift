//
//  LikeService.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 5/5/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation

public class LikeService {
    
    public let tag = "LikeService"
    public static let shared = LikeService()
    
    public var cached: [Int] {
        return likesVendors
    }
    
    private var likesVendors = [Int]()
    private var key = Constants.likedVendors
    
    private init() {
        // 1. Открыть список избранного в UserDefaults
        getLikesVendors()
        
        // 2. Обновить список избранного в KeyChain
        updateRemoteData()
    }
    
    public func load() {
        likesVendors.removeAll()
        loadLikesVendors()
    }
    
    private func loadLikesVendors() {
        if let vendors = UserDefaults.standard.object(forKey: Constants.likedVendors) as? [Int] {
            likesVendors = vendors
        }
    }
    
    private func getLikesVendors() {
        if let vendors = UserDefaults.standard.object(forKey: Constants.likedVendors) as? [Int] {
            likesVendors = vendors
        } else {
            fetchKeyChainData()
        }
    }
    
    private func fetchKeyChainData() {
        guard
            let vendorsData = KeychainWrapper.standard.data(forKey: key) else { return }
        do {
            let vendors = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(vendorsData) as? [Int]
            likesVendors = vendors ?? []
            updateUserDefaults()
        } catch { }
    }
    
    private func updateUserDefaults() {
        UserDefaults.standard.set(self.likesVendors, forKey: key)
    }
    
    private func updateRemoteData() {
        do {
            let vendorsData = try NSKeyedArchiver.archivedData(withRootObject: likesVendors, requiringSecureCoding: false)
            KeychainWrapper.standard.set(vendorsData, forKey: key)
        } catch  { }
    }
    
    public func checkLike(_ productId: Int) -> Bool {
        return likesVendors.contains(productId)
    }
    
    public func updateLike(_ productId: Int) {
        if likesVendors.contains(productId) {
            if let index = likesVendors.firstIndex(where: { $0 == productId }) {
                likesVendors.remove(at: index)
            }
        } else {
            likesVendors.append(productId)
        }
        
        updateUserDefaults()
    }
}
