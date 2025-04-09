//
//  RegistrationDetails.swift
//  moveMentorPhoneTest
//
//  Created by Kaleb Lee on 4/3/25.
//
import Foundation

class RegistrationData: ObservableObject {
    // Collected during CreateAccountView
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var dob: String = ""
    @Published var password: String = ""
    @Published var role: String = ""
    // Collected during multi-Onboarding Views
    
    @Published var gender = ""
    @Published var age = 0
    @Published var units = ""
    @Published var weight = 0.0
    @Published var height = 0.0
    @Published var goals = ""
    
}
