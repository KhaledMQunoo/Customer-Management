//
//  EditCustomerViewModelTests.swift
//  Customer ManagementTests
//
//  Created by Khaled on 14/06/2025.
//

import XCTest
@testable import Customer_Management

@MainActor
final class EditCustomerViewModelLiveTests: XCTestCase {

    var viewModel: EditCustomerViewModel!

    override func setUp() {
        super.setUp()
        viewModel = EditCustomerViewModel() // Use real WebService
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testUpdateCustomer_Live_Success() async {
        // Use a valid user ID from your backend (you can create a test user)
        let validUserId = 7946016

        // Prepare valid data
        let name = "Test User Updated"
        let email = "testuserupdated@example.com"
        let gender = "male"
        let status = "active"

        // Perform update
        await viewModel.updateCustomer(
            userId: validUserId,
            name: name,
            email: email,
            gender: gender,
            status: status
        )

        // Assert expected behavior
        XCTAssertFalse(viewModel.isLoading, "Loading should stop after request")
        XCTAssertNil(viewModel.errorMessage, "There should be no error message on success")
        XCTAssertNotNil(viewModel.successMessage, "Success message should be set")
        XCTAssertFalse(viewModel.showAlert, "Alert should not be shown on success")
    }

    func testUpdateCustomer_Live_InvalidEmail() async {
        let validUserId = 7946016

        await viewModel.updateCustomer(
            userId: validUserId,
            name: "Test User",
            email: "invalid-email",
            gender: "male",
            status: "active"
        )

        XCTAssertTrue(viewModel.showAlert, "Alert should be shown for invalid email")
        XCTAssertEqual(viewModel.alertMessage, "Invalid email address.")
        XCTAssertFalse(viewModel.isLoading)
    }

    func testUpdateCustomer_Live_EmptyName() async {
        let validUserId = 7946016

        await viewModel.updateCustomer(
            userId: validUserId,
            name: "",
            email: "valid@email.com",
            gender: "female",
            status: "active"
        )

        XCTAssertTrue(viewModel.showAlert, "Alert should be shown for empty name")
        XCTAssertEqual(viewModel.alertMessage, "Name cannot be empty.")
        XCTAssertFalse(viewModel.isLoading)
    }
}
