//
//  UserDetailViewModelTests.swift
//  Customer ManagementTests
//
//  Created by Khaled on 14/06/2025.
//
import XCTest
import CoreData
@testable import Customer_Management // Use your actual module name here

@MainActor
final class UserDetailViewModelLiveTests: XCTestCase {

    var viewModel: UserDetailViewModel!
    var context: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        // Setup in-memory Core Data context
        context = makeInMemoryContext()

        // Use real WebService
        viewModel = UserDetailViewModel()

    }

    override func tearDown() {
        viewModel = nil
        context = nil
        super.tearDown()
    }

    func makeInMemoryContext() -> NSManagedObjectContext {
        let container = NSPersistentContainer(name: "Customer_Management")
        // Replace "YourCoreDataModelName" with your actual .xcdatamodeld name

        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }

        return container.viewContext
    }

    func testFetchUserDetail_live() async throws {
        // Provide a valid user ID existing in your live backend
        let validUserId = 7946016

        // Call the async fetchUserDetail method
        await viewModel.fetchUserDetail(userId: validUserId, context: context)

        // Assert the user was fetched successfully
        XCTAssertNotNil(viewModel.user, "User should be fetched successfully")
        XCTAssertNil(viewModel.errorMessage, "There should be no error message")
        XCTAssertFalse(viewModel.isLoading, "Loading should be finished")
    }
}
