//
//  LaunchControllerDelegate.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 11/20/18.
//  Copyright © 2018 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation

public protocol LaunchControllerDelegate {
    
    var notNeedDisplay: Bool { get }
    var onCompleteHandler: Trigger? { get set }
    
    func hiddenProcessing()
}
