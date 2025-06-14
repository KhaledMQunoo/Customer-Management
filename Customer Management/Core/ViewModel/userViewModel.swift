//
//  userViewModel.swift
//  Customer Management
//
//  Created by Khaled on 12/06/2025.
//

import Foundation
import Combine
import CoreData

@MainActor
class UserViewModel: ObservableObject {
    
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var hasMoreData = true

    var currentPage = 1
    private let perPage = 10


    private let webService = WebService()

 
 
    
    func fetchUsers(reset: Bool = false, context: NSManagedObjectContext) async {

        guard !isLoading/*, hasMoreData*/ else { return }
        
        if reset {
            currentPage = 1
            hasMoreData = true
            users.removeAll()
        }

        isLoading = true

        let url = TAConstant.mainApiUrl + EndPoints.user.rawValue + "?page=\(currentPage)&per_page=\(perPage)"

        do {
            let fetchedUsers: [User] = try await webService.request(url: url, method: .get)

          
            
            users.append(contentsOf: fetchedUsers)
            // Cache new data
            cacheUsers(fetchedUsers, page: currentPage, context: context)
            
            if fetchedUsers.count < perPage {
                hasMoreData = false
            }else{
                currentPage += 1
            }



        } catch {
            print("❌ Error fetching users: \(error.localizedDescription)")
            print("📡 Switching to offline mode...")

            var offlinePage = currentPage

            while true {
                let countBefore = users.count
                loadCachedUsers(context: context, page: offlinePage)
                let countAfter = users.count

                if countAfter == countBefore {
                    // No new users found for this page
                    hasMoreData = false
                    break
                }

                offlinePage += 1
            }
            
            
        }

        isLoading = false
    }


    func resetUsers() {
        users.removeAll()
        currentPage = 1
        hasMoreData = true
    }
    
    
    
    func cacheUsers(_ users: [User], page: Int, context: NSManagedObjectContext) {
        var hasChanges = false

        for user in users {
            guard let userId = user.id else { continue }

            let fetchRequest: NSFetchRequest<CachedCustomer> = CachedCustomer.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", userId)
            fetchRequest.fetchLimit = 1

            let existing = try? context.fetch(fetchRequest).first

            let cached = existing ?? CachedCustomer(context: context)

            if cached.id != Int64(userId)
                || cached.name != user.name
                || cached.email != user.email
                || cached.gender != user.gender
                || cached.status != user.status
                || cached.page != Int32(page) {

                cached.id = Int64(userId)
                cached.name = user.name
                cached.email = user.email
                cached.gender = user.gender
                cached.status = user.status
                cached.page = Int32(page)

                hasChanges = true
            }
        }

        if hasChanges {
            do {
                try context.save()
                print("✅ Core Data updated with new or modified users")
            } catch {
                print("❌ Failed to save to Core Data: \(error)")
            }
        } else {
            print("ℹ️ No changes in user data, skipping Core Data save")
        }
    }


    
    func loadCachedUsers(context: NSManagedObjectContext, page: Int) {
        let fetchRequest: NSFetchRequest<CachedCustomer> = CachedCustomer.fetchRequest()
        
        // Filter by page
        fetchRequest.predicate = NSPredicate(format: "page == %d", page)

        // ✅ Match API order — newest first
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]

        do {
            let cached = try context.fetch(fetchRequest)
            
            if cached.isEmpty {
                       print("⚠️ No cached data found for page \(page)")
                    
                       return  // Don’t increment page if no data
                   }

            let mappedUsers = cached.map {
                User(
                    id: Int($0.id),
                    name: $0.name ?? "",
                    email: $0.email ?? "",
                    gender: $0.gender ?? "",
                    status: $0.status ?? ""
                )
            }

            // Append in correct order
            self.users.append(contentsOf: mappedUsers)
            print("✅ Loaded cached users from page \(page)")
            currentPage += 1
            
        } catch {
            print("❌ Error loading cached users: \(error)")
        }
    }

    func clearCachedCustomers(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CachedCustomer.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
            print("✅ Cleared cached customers")
        } catch {
            print("❌ Failed to clear cached customers: \(error)")
        }
    }
    
    func deleteCachedCustomer(withId id: Int, context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<CachedCustomer> = CachedCustomer.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        fetchRequest.fetchLimit = 1

        do {
            if let customer = try context.fetch(fetchRequest).first {
                context.delete(customer)
                try context.save()
                print("✅ Deleted customer with ID \(id) from cache")
            } else {
                print("⚠️ No cached customer found with ID \(id)")
            }
        } catch {
            print("❌ Failed to delete cached customer: \(error)")
        }
    }
    
    
}
