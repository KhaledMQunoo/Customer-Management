//
//  AddCustomerViewModelLiveTests.swift
//  Customer ManagementTests
//
//  Created by Khaled on 14/06/2025.
//

import XCTest
@testable import Customer_Management

@MainActor
final class AddCustomerViewModelLiveTests: XCTestCase {

    var viewModel: AddCustomerViewModel!

    override func setUp() {
        super.setUp()
        viewModel = AddCustomerViewModel() // Using real WebService
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testAddCustomer_Live_Success() async {
        // Generate unique email for each test run to avoid duplication
        let uniqueEmail = "test\(UUID().uuidString.prefix(8))@example.com"

        await viewModel.addCustomer(
            name: "Test User",
            email: uniqueEmail,
            gender: "male",
            status: "active"
        )

        // ✅ Assertions
        XCTAssertFalse(viewModel.isLoading, "Loading should stop after API call")
        XCTAssertNil(viewModel.errorMessage, "No error should occur on success")
        XCTAssertNotNil(viewModel.successMessage, "Success message should be set")
        XCTAssertFalse(viewModel.showAlert, "Alert should not be shown on success")
    }

    func testAddCustomer_Live_InvalidEmail() async {
        await viewModel.addCustomer(
            name: "Test User",
            email: "invalid-email",
            gender: "female",
            status: "active"
        )

        // ❌ Assertions
        XCTAssertTrue(viewModel.showAlert, "Alert should be shown for invalid email")
        XCTAssertEqual(viewModel.alertMessage, "Invalid email address.")
        XCTAssertFalse(viewModel.isLoading)
    }

    func testAddCustomer_Live_EmptyName() async {
        await viewModel.addCustomer(
            name: "",
            email: "test@example.com",
            gender: "male",
            status: "inactive"
        )

        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Name cannot be empty.")
        XCTAssertFalse(viewModel.isLoading)
    }

    func testAddCustomer_Live_EmptyEmail() async {
        await viewModel.addCustomer(
            name: "Test User",
            email: "",
            gender: "female",
            status: "inactive"
        )

        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Email cannot be empty.")
        XCTAssertFalse(viewModel.isLoading)
    }
}
