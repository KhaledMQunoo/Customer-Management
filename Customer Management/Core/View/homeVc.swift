//
//  homeVc.swift
//  Customer Management
//
//  Created by Khaled on 12/06/2025.
//

import SwiftUI

struct homeVc: View {
    
    @StateObject private var userVM = UserViewModel()
    @StateObject private var userDetailVM = UserDetailViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            // CustomerList =====
            customerList
        }
        .padding(.horizontal)
        .edgesIgnoringSafeArea(.bottom)
        
        // showing the message of error if something going wrong ===
        .alert(isPresented: $userDetailVM.showAlert, content: { alertView })

        //Push to refresh ====
        .refreshable {
            Task{
                await userVM.fetchUsers(reset: true, context: viewContext)
            }
        }
        
        //Request the Data ====
        .task {
            await userVM.fetchUsers(reset: true, context: viewContext)
        }
        
        //Add button + refresh when you finish adding ====
        .overlay(alignment: .bottom) {
            NavigationLink(
                destination: addCustomerVc(onAddCustomer: {
                    Task{
                        await userVM.fetchUsers(reset: true, context: viewContext)
                    }
                })
            ) {
                customerButton
            }
            
            //Full screen loading overlay
            if userVM.isLoading && userVM.users.isEmpty {
                LoadingOverlay(message: "Loading Customers...")
            }
        }
        
    }
    
    
    // MARK: - customer Cell
    @ViewBuilder
    func customerCell(user: User) -> some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .top) {
                    Text(user.name ?? "Name")
                        .font(.system(size: 18)).bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .accessibilityIdentifier("Name")
                    HStack(spacing: 6) {
                        Text(user.gender ?? "Gender")
                            .font(.system(size: 14)).bold()
                            .padding(5)
                        
                        Text(user.status ?? "Status")
                            .font(.system(size: 14)).bold()
                            .foregroundColor(user.status?.lowercased() == "active" ? Color("greenColor") : Color("redColor"))
                            .padding(5)
                            .background(Color("whiteColor"))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                }
                
                Text(user.email ?? "Email address")
                    .font(.system(size: 15))
                    .foregroundStyle(Color("darkGrayColor"))
                    .lineLimit(3)
            }
            .padding(.horizontal, 5)
            .padding(.vertical, 8)
            .background(Color("lightGrayColor"))
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
        .padding(.vertical, 3)
        .padding(.horizontal)
        .background(Color("whiteColor"))
    }
}


#Preview {
    mainVc()
}


extension homeVc{
    
    //Alert
    private var alertView: Alert {
        Alert(title: Text("Alert!"), message: Text(userDetailVM.alertMessage ?? ""), dismissButton: .default(Text("OK")) {
            // Optional: reset alert state when dismissed
            userDetailVM.showAlert = false
            userDetailVM.alertMessage = nil
        })
    }
    
    // MARK: - Welcoming Bar
    private var welcomingBar: some View {
        
        VStack{
            Text("Welcome!")
                .font(.callout)
                .frame(maxWidth: .infinity,alignment: .leading)
            
            Text("Here's your Customers !")
                .font(.title2.bold())
                .frame(maxWidth: .infinity,alignment: .leading)
        }
        
    }
    
    private var customerList: some View {
        List {
            // Welcome bar at the top
            welcomingBar
                .listRowSeparator(.hidden)
            
            // Loop through each customer
            ForEach(userVM.users, id: \.id) { user in
                ZStack {
                    // Invisible NavigationLink for tap navigation
                    NavigationLink(destination: customerDetailsVc(userId: user.id ?? 0)) {
                        EmptyView()
                    }
                    .opacity(0)
                    
                    // Customer cell view
                    customerCell(user: user)
                        .onAppear {
                            // Pagination logic: trigger fetch near end of list
                            if let index = userVM.users.firstIndex(where: { $0.id == user.id }),
                               index >= userVM.users.count - 3,
                               !userVM.isLoading {
                                Task {
                                    await userVM.fetchUsers(reset: false, context: viewContext)
                                }
                            }
                        }
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        Task {
                            await userDetailVM.deleteCustomer(userId: user.id ?? 0)
                            
                            if userDetailVM.successMessage != nil {
                                DispatchQueue.main.async {
                                    userVM.users.removeAll { $0.id == user.id }
                                    userVM.deleteCachedCustomer(withId: user.id ?? 0, context: viewContext)
                                }
                            }
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                            .accessibilityIdentifier("Delete")
                    }
                }
                .tint(.red)
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
            }
            
            // Pagination spinner at bottom of list
            if userVM.isLoading && !userVM.users.isEmpty {
                HStack {
                    Spacer()
                    VStack(spacing: 8) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding(5)
                            .cornerRadius(10)
                            .id(UUID())
                    }
                    .padding()
                    Spacer()
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color.clear)
        .padding(.horizontal, -20)
    }
    
    
    
    
    
    // MARK: - Add Customer Button
    private var customerButton: some View {
        
        HStack {
            Image(systemName: "plus.app.fill")
            Text("Add Customer")
                .font(.callout)
                .fontWeight(.semibold)
        }
        .padding()
        .foregroundColor(.white)
        .background(Color("mainBlueColor"))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 10)
        .frame(maxWidth: .infinity)
        
    }
    
}
