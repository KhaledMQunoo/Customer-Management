//
//  ContentView.swift
//  Customer Management
//
//  Created by Khaled on 12/06/2025.
//

import SwiftUI
import CoreData

struct mainVc: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        NavigationStack {
            
            homeVc()
//                .environmentObject(taskModel)
//                .environment(\.managedObjectContext, managedObjectContext)
                .navigationTitle("Customer Management")
                .navigationBarTitleDisplayMode(.inline)

        }
        .tint(Color("oppisiteWhiteColor"))

    }
}


#Preview {
    mainVc().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
