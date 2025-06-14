//
//  homeVc.swift
//  Customer ManagementUITests
//
//  Created by Khaled on 14/06/2025.
//

import XCTest

final class HomeVcUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testWelcomeTextsAreVisible() throws {
        let welcomeText = app.staticTexts["Welcome!"]
        let subtitleText = app.staticTexts["Here's your Customers !"]
        
        XCTAssertTrue(welcomeText.waitForExistence(timeout: 5), "Welcome text should appear")
        XCTAssertTrue(subtitleText.exists, "Subtitle welcome text should appear")
    }
    
    func testCustomerListLoads() throws {
        // Wait until any cell that contains text "Name" appears
        // Because your cells show the customer's name or default "Name"
        let firstCustomerCell = app.cells.containing(.staticText, identifier: "Name").firstMatch
        
        let exists = firstCustomerCell.waitForExistence(timeout: 10)
        XCTAssertTrue(exists, "At least one customer cell with 'Name' should load")
    }
    
}
