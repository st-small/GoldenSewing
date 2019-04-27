//
//  GoldenSewingUITests.swift
//  GoldenSewingUITests
//
//  Created by Stanly Shiyanovskiy on 4/26/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import XCTest

class GoldenSewingUITests: XCTestCase {

    func testExample() {
        
        // Загрузили приложение
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
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
        app.tables.buttons["Геральдика"].tap()
        snapshot("05HeraldryCategory")
    }
}
