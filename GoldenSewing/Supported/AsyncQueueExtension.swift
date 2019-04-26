//
//  AsyncQueueExtension.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 11/25/18.
//  Copyright © 2018 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation

extension AsyncQueue {
    
    public static func createForControllerLoad(for tag: String) -> AsyncQueue {
        return AsyncQueue.custom(DispatchQueue.createControllerLoadQueue(for: tag))
    }
    public static func createForApi(for tag: String) -> AsyncQueue {
        return AsyncQueue.custom(DispatchQueue.createApiQueue(for: tag))
    }
}

extension DispatchQueue {
    public static func createControllerLoadQueue(for tag: String) -> DispatchQueue {
        return DispatchQueue.init(label: "\(tag)-controller-load", qos: DispatchQoS.userInitiated, attributes: [], autoreleaseFrequency: .inherit, target: nil)
    }
    public static func createApiQueue(for tag: String) -> DispatchQueue {
        return DispatchQueue.init(label: "\(tag)-api-requests", qos: DispatchQoS.utility, attributes: [], autoreleaseFrequency: .inherit, target: nil)
    }
}
