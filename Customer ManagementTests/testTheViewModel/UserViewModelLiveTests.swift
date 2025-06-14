//
//  UserViewModelLiveTests.swift
//  Customer ManagementTests
//
//  Created by Khaled on 14/06/2025.
//

import XCTest
import CoreData
@testable import Customer_Management

@MainActor
final class UserViewModelLiveTests: XCTestCase {

    var viewModel: UserViewModel!
    var context: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        
        // Setup in-memory Core Data context
        context = makeInMemoryContext()

        viewModel = UserViewModel()
    }

    override func tearDown() {
        viewModel = nil
        context = nil
        super.tearDown()
    }

    // MARK: - Tests

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

    
    func testFetchUsers_Live_SuccessAndCaching() async {
        // 1. Fetch users from live API
        await viewModel.fetchUsers(reset: true, context: context)

        // ✅ Assertions for live fetch
        XCTAssertFalse(viewModel.users.isEmpty, "Users should be fetched from live API")
        XCTAssertFalse(viewModel.isLoading, "Loading state should be false after fetch")
        XCTAssertTrue(viewModel.currentPage > 1 || !viewModel.hasMoreData, "Pagination should advance")

    }



}
