//
//  GoldenSewingUITests.swift
//  GoldenSewingUITests
//
//  Created by Stanly Shiyanovskiy on 4/26/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import XCTest

@testable import GoldenSewing

class GoldenSewingUITests: XCTestCase {
    
    private let app = XCUIApplication()
    
    override public func setUp() {
        super.setUp()
        app.launch()
        
        addUIInterruptionMonitor(withDescription: "\"GoldenSewing\" Would Like to Send You Notifications") {
            (alert) -> Bool in
            
            let okButton = alert.buttons["OK"]
            if okButton.exists {
                okButton.tap()
            }
            
            let allowButton = alert.buttons["Allow"]
            if allowButton.exists {
                allowButton.tap()
            }
            
            let allowRussianButton = alert.buttons["Разрешить"]
            if allowRussianButton.exists {
                allowRussianButton.tap()
            }
            
            return true
        }
        
        app.tap()
    }
    
    override func tearDown() {
        Springboard.deleteMyApp(name: "Золотое шитьё")
        super.tearDown()
    }
    
    public func testOnboarding() {
        
        addUIInterruptionMonitor(withDescription: "\"GoldenSewing\" Would Like to Send You Notifications") {
            (alert) -> Bool in
            
            let okButton = alert.buttons["OK"]
            if okButton.exists {
                okButton.tap()
            }
            
            let allowButton = alert.buttons["Allow"]
            if allowButton.exists {
                allowButton.tap()
            }
            
            let allowRussianButton = alert.buttons["Разрешить"]
            if allowRussianButton.exists {
                allowRussianButton.tap()
            }
            
            return true
        }
        
        app.tap()
        
        let scrollView = app.scrollViews["OnboardingScroll"]
        XCTAssertTrue(scrollView.waitForExistence(timeout: 3.0))
        sleep(UInt32(1))
        
        repeat {
            scrollView.swipeLeft()
        } while self.app.buttons["Пропустить"].exists
        
        app.buttons["Вход"].tap()
    }

    public func testToTakeSnapshots() {
        
        app.buttons["Пропустить"].tap()
        
        XCTAssertTrue(app.tables["categoriesTable"].waitForExistence(timeout: 5.0))
        snapshot("01CategoriesItems")
        
        // Открыли раздел "Митры"
        if UIScreen.main.bounds.width == 414.0 {
            app.collectionViews.buttons["Митры архиерейские, иерейские"].tap()
            snapshot("02MitresCategory")
        } else if UIScreen.main.bounds.width == 320.0 {
            let table = app.tables.element(boundBy: 0)
            table.buttons["Комплекты вышивки для сборки митр"].swipeUp()
            table.buttons["Митры архиерейские, иерейские"].tap()
            snapshot("02MitresCategory")
        } else {
            app.tables.buttons["Митры архиерейские, иерейские"].tap()
            snapshot("02MitresCategory")
        }
        
        // Нажали поиск и ввели номер артикула 9197
        app.navigationBars["Митры архиерейские, иерейские"].buttons["Search"].tap()
        app.otherElements.containing(.navigationBar, identifier:"Митры архиерейские, иерейские").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .searchField).element.tap()
        
        sleep(UInt32(10))
        
        let moreKey = app/*@START_MENU_TOKEN@*/.keys["more"]/*[[".keyboards",".keys[\"more, numbers\"]",".keys[\"more\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        moreKey.tap()
        
        let key = app/*@START_MENU_TOKEN@*/.keys["9"]/*[[".keyboards.keys[\"9\"]",".keys[\"9\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        key.tap()
        
        let key2 = app/*@START_MENU_TOKEN@*/.keys["1"]/*[[".keyboards.keys[\"1\"]",".keys[\"1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        key2.tap()
        key.tap()
        
        let key3 = app/*@START_MENU_TOKEN@*/.keys["7"]/*[[".keyboards.keys[\"7\"]",".keys[\"7\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        key3.tap()
        snapshot("03FindItemByVendorCode")
        
        // Открываем экран детального просмотра
        app.collectionViews/*@START_MENU_TOKEN@*/.staticTexts["Митра Архиерейская"]/*[[".cells.staticTexts[\"Митра Архиерейская\"]",".staticTexts[\"Митра Архиерейская\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        snapshot("04ProductDetailView")
        
        // Возвращаемся обратно в каталог
        app.navigationBars["Митра Архиерейская, 9197"].buttons["Back"].tap()
        app.navigationBars["Митры архиерейские, иерейские"].buttons["Back"].tap()
        
        // Выбираем категорию "Геральдика"
        app.tables.buttons["Митры архиерейские, иерейские"].swipeDown()
        sleep(UInt32(1))
        app.tables.buttons["Геральдика"].tap()
        
        XCTAssertTrue(app.collectionViews["OtherProducts"].waitForExistence(timeout: 5.0))
        snapshot("05HeraldryCategory")
    }
}

public class Springboard {
    
    static let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
    
    /**
     Terminate and delete the app via springboard
     */
    class func deleteMyApp(name: String) {
        XCUIApplication().terminate()
        
        // Force delete the app from the springboard
        let icon = springboard.icons[name]
        if icon.exists {
            icon.press(forDuration: 2.0)
            
            icon.buttons["DeleteButton"].tap()
            sleep(2)
            springboard.alerts["Delete “\(name)”?"].buttons["Delete"].tap()
            sleep(2)
            
            XCUIDevice.shared.press(.home)
        }
    }
}
