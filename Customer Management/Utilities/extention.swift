//
//  extention.swift
//  Customer Management
//
//  Created by Khaled on 13/06/2025.
//

import SwiftUI

extension View {
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension String {
    
    func isValidEmail() -> Bool {
        let emailRegEx = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: self)
    }
    
}


extension View {
    func successBanner(message: String, show: Bool, onAppearTask: (() async -> Void)? = nil) -> some View {
        self.modifier(SuccessBannerModifier(message: message, show: show, onAppearTask: onAppearTask))
    }
  
}
