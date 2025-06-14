//
//  SplashRootView.swift
//  Customer Management
//
//  Created by Khaled on 14/06/2025.
//

import SwiftUI

struct SplashRootView: View {
    @State private var isActive = false

    var body: some View {
        Group {
            if isActive {
                mainVc() // your main UI
            } else {
                SplashScreen()
            }
        }
        .onAppear {
            // Simulate loading time (e.g. 2 seconds)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    isActive = true
                }
            }
        }
    }
}

struct SplashScreen: View {
    @State private var textOpacity = 0.0
    @State private var textScale: CGFloat = 0.8

    var body: some View {
        ZStack {
            Color("mainBlueColor")
                .ignoresSafeArea()

            Text("Customer Management")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .opacity(textOpacity)
                .scaleEffect(textScale)
                .onAppear {
                    withAnimation(.easeOut(duration: 1.5)) {
                        textOpacity = 1.0
                        textScale = 1.0
                    }
                }
        }
    }
}

#Preview {
    SplashRootView()
}

