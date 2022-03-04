//
//  JPNasaAPODUITests.swift
//  JPNasaAPODUITests
//
//  Created by kumaresh shrivastava on 19/01/2022.
//

import XCTest

class JPNasaAPODUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    func test_ApodHomeScreen_textfield_picker_tap_cancel_done_Visible() {

        let app = XCUIApplication()
        app.launch()
        let textField = app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element
        let toolBarCancelButton =  app.toolbars["Toolbar"].buttons["Cancel"]
        let tootlbarDoneButton = app.toolbars["Toolbar"].buttons["Done"]
        let datePickersQuery = app.datePickers.element
        
        XCTAssertTrue(textField.exists)
        XCTAssertFalse(tootlbarDoneButton.exists)
        XCTAssertFalse(toolBarCancelButton.exists)
        XCTAssertFalse(datePickersQuery.exists)
        textField.tap()
        XCTAssertTrue(datePickersQuery.exists)
        XCTAssertTrue(tootlbarDoneButton.exists)
        XCTAssertTrue(toolBarCancelButton.exists)
        toolBarCancelButton.tap()
        XCTAssertFalse(toolBarCancelButton.exists)
        XCTAssertFalse(tootlbarDoneButton.exists)
        XCTAssertFalse(datePickersQuery.exists)
        
        textField.tap()
        XCTAssertTrue(datePickersQuery.exists)
        XCTAssertTrue(tootlbarDoneButton.exists)
        XCTAssertTrue(toolBarCancelButton.exists)
        tootlbarDoneButton.tap()
        XCTAssertFalse(toolBarCancelButton.exists)
        XCTAssertFalse(tootlbarDoneButton.exists)
        XCTAssertFalse(datePickersQuery.exists)

    }
    
}
