//
//  userModel.swift
//  Customer Management
//
//  Created by Khaled on 12/06/2025.
//

import Foundation


// MARK: - User
struct User: Codable,Identifiable {
    let id: Int?
    let name, email: String?
    let gender: String?
    let status: String?
}
