//
//  OnboardingTests.swift
//  Golden Sewing Tests
//
//  Created by Stanly Shiyanovskiy on 5/20/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import XCTest

@testable import GoldenSewing

public class Onboarding_mock: OnboardingView {
    
}

public class OnboardingTests: XCTestCase {
    
    private let onboarding = Onboarding_mock()
    
    public override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    public override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    public func testExample() {
        let nav = UINavigationController()
        nav.present(onboarding, animated: true, completion: nil)
    }
}
