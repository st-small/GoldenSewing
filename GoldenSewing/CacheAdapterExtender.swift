//
//  CacheAdapterExtender.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 11/25/18.
//  Copyright © 2018 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation

open class CacheAdapterExtender<TElement> where TElement: ICached  {
    
    private let adapter: CacheAdapter<TElement>
    
    public init(for adapter: CacheAdapter<TElement>) {
        self.adapter = adapter
    }
    
//    public var all: [CategoryModel] {
//        return adapter.data.map({ $0 }).map({ $0.data })
//    }
//    public func `where`(_ predicate: @escaping ((TElement) -> Bool)) -> [CategoryModel] {
//        return adapter.data.where({ predicate($0.data)! }).map{ $0.data }
//    }
//    public func find(_ id: Int) -> CategoryModel? {
//        return adapter.data.filter({ $0.data.id == id }).first?.data
//    }
//    public func find(_ predicate:@escaping ((CategoryModel) -> Bool)) -> TElement? {
//        
//        if let result = adapter.data.find({ predicate($0.data!) }) {
//            return CategoryModel(source: result.data)
//        }
//        else {
//            return nil
//        }
//    }
    
//    public func range(_ ids: [Int]) -> [CategoryModel] {
//        return adapter.data.where({ ids.contains($0.id) }).map{ $0.data }
//    }
//    public func check(_ range: [Int]) -> CacheSearchResult {
//        
//        var cached = [TElement]()
//        var notFound = [Int]()
//        
//        let data = adapter.data
//        for id in range {
//            
//            if let index = data.index(where: { $0.id == id}) {
//                cached.append(data[index].data)!
//            }
//            else {
//                notFound.append(id)
//            }
//        }
//        
//        return CacheSearchResult<TElement>(cached: cached, notFound: notFound)
//    }
//    public func isFresh(_ id: Int) -> Bool {
//        
//        guard let container = adapter.data.find({ $0.id == id }) else {
//            return false
//        }
//        
//        return container.isFresh
//    }
    
//    public func clear() {
//        adapter.clear()
//    }
}
