//
//  ProfileLink.swift
//  moveMentorPhoneTest
//
//  Created by Kaleb Lee on 4/4/25.
//

import Foundation

struct ProfileAuthResponse: Codable {
    let id: Int
    let username: String
    let email: String
    let firstName: String
    let lastName: String
    let role: String
    let access: String
    let refresh: String
    let age: Int?
    let weight: Double?
    let height: Double?
}

class UserSession: ObservableObject{
    @Published var id: Int?
    @Published var username: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var age: Int?
    @Published var weight: Double?
    @Published var height: Double?
    @Published var role: String = ""
    @Published var isAuthenticated: Bool = false
    @Published var joinedYear: Int?
}
