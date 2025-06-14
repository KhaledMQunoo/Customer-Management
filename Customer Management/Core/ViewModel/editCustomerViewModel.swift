//
//  editCustomerViewModel.swift
//  Customer Management
//
//  Created by Khaled on 13/06/2025.
//

import Foundation

@MainActor
class EditCustomerViewModel: ObservableObject {
    
    @Published var alertMessage: String?
    @Published var showAlert: Bool = false

    @Published var isLoading = false
    @Published var successMessage: String?
    @Published var errorMessage: String?
    
    private let webService = WebService()
    
    struct UpdatedUser: Codable {
        let name: String
        let email: String
        let gender: String // "male" or "female"
        let status: String // "active" or "inactive"
    }
    
 
    
    func updateCustomer(userId: Int,name: String,email: String,gender: String,status: String) async {
        
        isLoading = true
        errorMessage = nil
        successMessage = nil
        alertMessage = nil
        showAlert = false

        // Validate empty fields
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "Name cannot be empty."
            showAlert = true
            isLoading = false
            return
        }
        
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "Email cannot be empty."
            showAlert = true
            isLoading = false
            return
        }

        // Validate email format
        guard email.isValidEmail() else {
            alertMessage = "Invalid email address."
            showAlert = true
            isLoading = false
            return
        }
        
        // Build URL with userId
        let url = TAConstant.mainApiUrl + EndPoints.user.rawValue + "/\(userId)"
        
        let updatedUser = UpdatedUser(name: name, email: email, gender: gender, status: status)
        
        // Convert to dictionary for request body
        guard let parameters = try? DictionaryEncoder().encode(updatedUser) else {
            errorMessage = "Invalid user data."
            isLoading = false
            return
        }
        
        do {
            let updatedUserResponse: User = try await webService.request(
                url: url,
                method: .put, // or .patch depending on your API
                parameters: parameters
            )
            successMessage = "✅ Customer updated: \(updatedUserResponse.name ?? "Unknown")"
        } catch {
            errorMessage = "❌ Failed to update customer: \(error.localizedDescription)"
            alertMessage = errorMessage
            showAlert = true
        }
        
        isLoading = false
    }
    
    
}
