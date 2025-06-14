//
//  addCustomerVc.swift
//  Customer Management
//
//  Created by Khaled on 12/06/2025.
//

import SwiftUI

struct addCustomerVc: View {
    
    var onAddCustomer: (() -> Void)?
    
    @State var nameText:String = ""
    @State var emailText:String = ""
    @State var genderText:String = "Male"
    @State var statusText:String = "Active"

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject private var addCustomerVM = AddCustomerViewModel()
    @State private var showSuccessBanner = false

    var body: some View {
        
        //Add scorll if you flip the screen or small iphone ===
        ScrollView {
            
            //the form ===
              formData
              
          }
        // hide the keyboard when you press anywhere in scroll ===
        .onTapGesture {
              hideKeyboard()
          }
        // Show success banner when you add customer ===
          .overlay(alignment: .top, content: { successBanner })
        
        // showing loading when you request adding api ===
          .overlay(content: { loadingOverlay })
        
        // showing the message of error if something going wrong ===
          .alert(isPresented: $addCustomerVM.showAlert, content: { alertView })
        
        //Navigation ===
          .navigationTitle("Add Customer")
          .navigationBarTitleDisplayMode(.inline)
        
      }
  }

#Preview {
    addCustomerVc()
    
}


extension addCustomerVc {
    
    // Loading Overlay
    private var loadingOverlay: some View {
        Group {
            if addCustomerVM.isLoading {
                LoadingOverlay(message: "Adding Customer...")
                    .transition(.opacity)
            }
        }
    }
    
       
       // Success Notification Banner
       private var successBanner: some View {
           Group {
               if showSuccessBanner {
                   Text("Customer added successfully!")
                       .font(.callout)
                       .foregroundColor(.white)
                       .padding()
                       .background(Color.green.opacity(0.9))
                       .cornerRadius(10)
                       .padding(.top, 10)
                       .transition(.move(edge: .top).combined(with: .opacity))
               }
           }
       }
    
    //Alert
    private var alertView: Alert {
        Alert(title: Text("Alert!"), message: Text(addCustomerVM.alertMessage ?? ""), dismissButton: .default(Text("OK")) {
            // Optional: reset alert state when dismissed
            addCustomerVM.showAlert = false
            addCustomerVM.alertMessage = nil
        })
    }
    
    
    // MARK: - form Data
    private var formData: some View {
        VStack(alignment: .leading) {
            // --- Name field ---
            Text("Name").font(.system(size: 14)).foregroundStyle(.gray)
            TextField("Enter your name", text: $nameText)
                .padding()
                .background(Color("lightGrayColor"))
                .cornerRadius(8)
                .padding(.bottom, 10)
            
            // --- Email field ---
            Text("Email").font(.system(size: 14)).foregroundStyle(.gray)
            TextField("Enter your Email", text: $emailText)
                .keyboardType(.emailAddress)
                .padding()
                .background(Color("lightGrayColor"))
                .cornerRadius(8)
                .padding(.bottom, 10)
            
            // --- Gender Picker ---
            Text("Gender").font(.system(size: 14)).foregroundStyle(.gray)
            HStack {
                ForEach(["Male", "Female"], id: \.self) { gender in
                    Text(gender)
                        .padding(8)
                        .frame(maxWidth: .infinity)
                        .background(
                            Capsule().fill(genderText == gender ? Color("mainBlueColor") : .clear)
                        )
                        .foregroundStyle(genderText == gender ? .white : Color("oppisiteWhiteColor"))
                        .overlay(
                            Capsule().stroke(Color("mainBlueColor"), lineWidth: genderText == gender ? 0 : 0.6)
                        )
                        .onTapGesture {
                            hideKeyboard()
                            genderText = gender
                        }
                }
            }
            .padding(.bottom, 10)
            
            // --- Status Picker ---
            Text("Status").font(.system(size: 14)).foregroundStyle(.gray)
            HStack {
                ForEach(["Active", "inactive"], id: \.self) { status in
                    Text(status)
                        .padding(8)
                        .frame(maxWidth: .infinity)
                        .background(
                            Capsule().fill(statusText == status ? Color("mainBlueColor") : .clear)
                        )
                        .foregroundStyle(statusText == status ? .white : Color("oppisiteWhiteColor"))
                        .overlay(
                            Capsule().stroke(Color("mainBlueColor"), lineWidth: statusText == status ? 0 : 0.6)
                        )
                        .onTapGesture {
                            hideKeyboard()
                            statusText = status
                        }
                }
            }
            .padding(.bottom, 30)
            
            // --- Add Button ---
            Button {
                Task {
                    await addCustomerVM.addCustomer(
                        name: nameText,
                        email: emailText,
                        gender: genderText.lowercased(),
                        status: statusText.lowercased()
                    )

                    if addCustomerVM.successMessage != nil {
                        hideKeyboard()
                        withAnimation {
                            showSuccessBanner = true
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            withAnimation {
                                showSuccessBanner = false
                            }
                            onAddCustomer?()
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            } label: {
                Text("Add Customer")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .foregroundStyle(Color.white)
                    .background(Capsule().fill(Color("mainBlueColor")))
                    .shadow(radius: 10)

            }
            
            Spacer()

        }
        .padding()
    }
}

