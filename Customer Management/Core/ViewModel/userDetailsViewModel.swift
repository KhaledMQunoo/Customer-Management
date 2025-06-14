//
//  userDetailsViewModel.swift
//  Customer Management
//
//  Created by Khaled on 13/06/2025.
//

import Foundation
import Network
import CoreData

@MainActor
class UserDetailViewModel: ObservableObject {
    
    @Published var user: User?
    @Published var isLoading = false
    @Published var errorMessage: String?

    @Published var alertMessage: String?
    @Published var showAlert: Bool = false
    @Published var successMessage: String?

    private let webService = WebService()
//    private let webService: WebService
//
//     init(webService: WebService = WebService()) {
//         self.webService = webService
//     }
    
    // MARK: - Delete Customer
     func deleteCustomer(userId: Int) async {
         isLoading = true
         errorMessage = nil
         successMessage = nil
         alertMessage = nil
         showAlert = false

         let url = TAConstant.mainApiUrl + EndPoints.user.rawValue + "/\(userId)"
         
         do {
             let _: EmptyResponse = try await webService.request(
                 url: url,
                 method: .delete,
                 parameters: nil as [String: Any]?
             )
   
             successMessage = "✅ Customer deleted successfully."
         } catch {
             errorMessage = "❌ Failed to delete customer: \(error.localizedDescription)"
             alertMessage = errorMessage
             showAlert = true
         }

         isLoading = false
     }
    
    func fetchUserDetail(userId: Int, context: NSManagedObjectContext) async {
        isLoading = true
        errorMessage = nil
        user = nil

        if await !isConnectedToInternet() {
            print("⚠️ No internet, trying to load from cache")
            loadCachedUser(userId: userId, context: context)
            if user == nil {
                errorMessage = "No internet connection and no cached data found."
            }
            isLoading = false
            return
        }

        let url = TAConstant.mainApiUrl + EndPoints.user.rawValue + "/\(userId)"

        do {
            let fetchedUser: User = try await webService.request(url: url, method: .get)
            self.user = fetchedUser
            
        } catch {
            print("❌ Failed to fetch online, trying offline fallback")
            loadCachedUser(userId: userId, context: context)
            if user == nil {
                errorMessage = "Failed to fetch user details: \(error.localizedDescription)"
            }
        }

        isLoading = false
    }

    private func isConnectedToInternet() async -> Bool {
        await withCheckedContinuation { continuation in
            let monitor = NWPathMonitor()
            let queue = DispatchQueue(label: "InternetCheck")
            monitor.pathUpdateHandler = { path in
                monitor.cancel()
                continuation.resume(returning: path.status == .satisfied)
            }
            monitor.start(queue: queue)
        }
    }

    private func loadCachedUser(userId: Int, context: NSManagedObjectContext) {
        let request: NSFetchRequest<CachedCustomer> = CachedCustomer.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", userId)
        request.fetchLimit = 1

        do {
            if let cached = try context.fetch(request).first {
                self.user = User(
                    id: Int(cached.id),
                    name: cached.name ?? "",
                    email: cached.email ?? "",
                    gender: cached.gender ?? "",
                    status: cached.status ?? ""
                )
                print("✅ Loaded user from Core Data cache")
            } else {
                print("❌ No cached user found for ID \(userId)")
            }
        } catch {
            print("❌ Core Data fetch error: \(error)")
        }
    }


}
