//
//  customerDetailsVc.swift
//  Customer Management
//
//  Created by Khaled on 12/06/2025.
//


import SwiftUI

struct customerDetailsVc: View {
    
    let userId: Int
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var userDetailVM = UserDetailViewModel()
    @StateObject private var EditCustomerVM = EditCustomerViewModel()
    @StateObject private var userVM = UserViewModel()
    
    @State private var showDeleteConfirmation = false
    @State private var showSuccessBanner = false
    
    @State var nameText: String = ""
    @State var emailText: String = ""
    @State var genderText: String = "Male"
    @State var statusText: String = "Active"
    
    
    // check if form has edit or not ===
    var isFormChanged: Bool {
        nameText != userDetailVM.user?.name ?? "" ||
        emailText != userDetailVM.user?.email ?? "" ||
        genderText.lowercased() != (userDetailVM.user?.gender ?? "").lowercased() ||
        statusText.lowercased() != (userDetailVM.user?.status ?? "").lowercased()
    }
    
    var body: some View {
        //Add scorll if you flip the screen or small iphone ===
        ScrollView {
            // Check if data loading or already there or no data ===
            VStack {
                if userDetailVM.isLoading {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let user = userDetailVM.user {
                    detailsData(user: user)
                } else {
                    Text("No data")
                        .foregroundColor(.gray)
                }
            }
        }
        // hide the keyboard when you press anywhere in scroll ===
        .onTapGesture {
            hideKeyboard()
        }
        
        // show delete confirmaiton alert or api erorr===
           .alert(isPresented: Binding(
            get: { showDeleteConfirmation || EditCustomerVM.showAlert || userDetailVM.showAlert},
               set: { newValue in
                   if !newValue {
                       showDeleteConfirmation = false
                       EditCustomerVM.showAlert = false
                       userDetailVM.showAlert = false
                   }
               }
           )) {
               if showDeleteConfirmation {
                   return deleteConfirmationAlert
               }else if EditCustomerVM.showAlert{
                   return apiEditErrorAlert
               } else {
                   return apiUserErrorAlert
               }
           }
        
        // show successBar if update customer ===
        .successBanner(message: "Customer updated successfully!",show: showSuccessBanner,
                       onAppearTask: {
            await userDetailVM.fetchUserDetail(userId: userId, context: viewContext)
        })
        
        // show progress when you edit ===
        .overlay(loadingOverlay)
        
        //navigation ===
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        
        //Request the cutomer details ===
        .task {
            await userDetailVM.fetchUserDetail(userId: userId, context: viewContext)
        }
        
        //update the data in my varuble when you recive the new data ===
        .onReceive(userDetailVM.$user) { newUser in
            if let user = newUser {
                nameText = user.name ?? ""
                emailText = user.email ?? ""
                genderText = user.gender ?? "Male"
                statusText = user.status ?? "Active"
            }
        }
    }
}

#Preview {
    customerDetailsVc(userId: 7439689)
}

extension customerDetailsVc {
    
    // Loading Overlay
    private var loadingOverlay: some View {
        Group {
            if EditCustomerVM.isLoading {
                LoadingOverlay(message: "Editing Customer...")
                    .transition(.opacity)
            }
        }
    }
    
    private var deleteConfirmationAlert: Alert {
        Alert(
            title: Text("Confirm Delete"),
            message: Text("Are you sure you want to delete the customer?"),
            primaryButton: .destructive(Text("Yes")) {
                Task {
                    await userDetailVM.deleteCustomer(userId: userDetailVM.user?.id ?? 0)
                    if userDetailVM.successMessage != nil {
                        userVM.users.removeAll { $0.id == userDetailVM.user?.id ?? 0 }
                        userVM.deleteCachedCustomer(withId: userDetailVM.user?.id  ?? 0, context: viewContext)
                        
                        showSuccessBanner = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            },
            secondaryButton: .cancel(Text("No"))
        )
    }
    
    private var apiEditErrorAlert: Alert {
        Alert(
            title: Text("Alert!"),
            message: Text(EditCustomerVM.alertMessage ?? "Something went wrong."),
            dismissButton: .default(Text("OK")) {
                EditCustomerVM.showAlert = false
                EditCustomerVM.alertMessage = nil
            }
        )
    }
    
    private var apiUserErrorAlert: Alert {
        Alert(
            title: Text("Alert!"),
            message: Text(userDetailVM.alertMessage ?? "Something went wrong."),
            dismissButton: .default(Text("OK")) {
                EditCustomerVM.showAlert = false
                EditCustomerVM.alertMessage = nil
            }
        )
    }
    // MARK: - form Data
    private func detailsData(user: User) -> some View {
        VStack(alignment: .leading) {
            Text("Customer Details!")
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 10)
            
            Text("Name").font(.system(size: 14)).foregroundStyle(.gray)
            TextField("Enter your name", text: $nameText)
                .padding(10)
                .background(Color("lightGrayColor"))
                .cornerRadius(8)
            
            Divider().padding(.vertical, 2)
            
            Text("Email").font(.system(size: 14)).foregroundStyle(.gray)
            TextField("Enter your Email", text: $emailText)
                .keyboardType(.emailAddress)
                .padding(10)
                .background(Color("lightGrayColor"))
                .cornerRadius(8)
            
            Divider().padding(.vertical, 2)
            
            Text("Gender").font(.system(size: 14)).foregroundStyle(.gray)
            Menu {
                Button("Male") { genderText = "male" }
                Button("Female") { genderText = "female" }
            } label: {
                HStack {
                    Text(genderText)
                    Image(systemName: "chevron.down")
                }
                .padding(10)
                .background(Color("lightGrayColor"))
                .cornerRadius(8)
            }
            
            Divider().padding(.vertical, 2)
            
            Text("Status").font(.system(size: 14)).foregroundStyle(.gray)
            Menu {
                Button("Active") { statusText = "active" }
                Button("Inactive") { statusText = "inactive" }
            } label: {
                HStack {
                    Text(statusText)
                        .foregroundColor(statusText.lowercased() == "active" ? Color("greenColor") : Color("redColor"))
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding(8)
                .background(Color("lightGrayColor"))
                .cornerRadius(8)
            }
            
            Spacer().frame(height: 20)
            
            HStack {
                
                // Delete Buttun ===
                Button {
                    
                    // If you press it will show the alert for confirmation ===
                    showDeleteConfirmation = true
                } label: {
                    Text("Delete")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .foregroundStyle(.white)
                        .background(Capsule().fill(Color("redColor")))
                        .shadow(radius: 10)
                }
                
                // Edit Button ((note the button will not work until you change)) =====
                Button {
                    Task {
                        await EditCustomerVM.updateCustomer(
                            userId: user.id ?? 0,
                            name: nameText,
                            email: emailText,
                            gender: genderText.lowercased(),
                            status: statusText.lowercased()
                        )
                        
                        if EditCustomerVM.successMessage != nil {
                            hideKeyboard()
                            withAnimation {
                                showSuccessBanner = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation {
                                    showSuccessBanner = false
                                }
                            }
                        }
                    }
                } label: {
                    Text("Edit")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .foregroundStyle(.white)
                        .background(Capsule().fill(isFormChanged ? Color("mainBlueColor") : Color.gray))
                        .shadow(radius: 10)
                }
                .disabled(!isFormChanged)
            }
            
            Spacer()
        }
        .padding()
    }
    
}
