//
//  Utility.swift
//  Customer Management
//
//  Created by Khaled on 14/06/2025.
//

import Foundation
import SwiftUI

struct LoadingOverlay: View {
    var message: String = "Loading..."

    var body: some View {
        ZStack {
            Color.black.opacity(0.25)
                .ignoresSafeArea()

            ProgressView(message)
                .padding(20)
                .background(Color("whiteColor"))
                .cornerRadius(10)
        }
    }
}

struct SuccessBannerModifier: ViewModifier {
    let message: String
    let show: Bool
    let onAppearTask: (() async -> Void)?

    func body(content: Content) -> some View {
        VStack {
            if show {
                Text(message)
                    .font(.callout)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green.opacity(0.9))
                    .cornerRadius(10)
                    .padding(.top, 10)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .task {
                        await onAppearTask?()
                    }
            }
            content
        }
    }
}
