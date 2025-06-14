//
//  AddCustomerViewModel.swift
//  Customer Management
//
//  Created by Khaled on 13/06/2025.
//

import Foundation

@MainActor
class AddCustomerViewModel: ObservableObject {
    
    @Published var alertMessage: String?
    @Published var showAlert: Bool = false

    @Published var isLoading = false
    @Published var successMessage: String?
    @Published var errorMessage: String?
    
    private let webService = WebService()
    
    struct NewUser: Codable {
        let name: String
        let email: String
        let gender: String
        let status: String
    }
    
    //Add customer function ===
    func addCustomer(name: String, email: String, gender: String, status: String) async {
        
        isLoading = true
        errorMessage = nil
        successMessage = nil
        
        alertMessage = nil
        showAlert = false

        // Validate Name empty fields
           guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
               alertMessage = "Name cannot be empty."
               showAlert = true
               isLoading = false
               return
           }
           
        // Validate Email empty fields
           guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
               alertMessage = "Email cannot be empty."
               showAlert = true
               isLoading = false
               return
           }

        // Validate email first
            guard email.isValidEmail() else {
                alertMessage = "Invalid email address."
                showAlert = true
                isLoading = false
                return
            }
             
        let url = TAConstant.mainApiUrl + EndPoints.user.rawValue
        let newUser = NewUser(name: name, email: email, gender: gender, status: status)
        
        // Convert to dictionary
        guard let parameters = try? DictionaryEncoder().encode(newUser) else {
            
            errorMessage = "Invalid user data."
            isLoading = false
            return
        }
        
        do {
            let createdUser: User = try await webService.request(
                url: url,
                method: .post,
                parameters: parameters
            )
            successMessage = "✅ Customer added: \(createdUser.name ?? "Unknown")"
        } catch {
            errorMessage = "❌ Failed to add customer"
            alertMessage = errorMessage
            showAlert = true
            isLoading = false

        }
        
        isLoading = false
    }
    
   
}


