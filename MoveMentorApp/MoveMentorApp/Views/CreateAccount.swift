//
//  CreateAccount.swift
//  MoveMentorDraft
//
//  Created by Kaleb Lee on 3/11/25.
//  Modified by Chase Sansom on 4/6/25.

import SwiftUI

struct CreateAccountView: View {
    @EnvironmentObject var registrationData: RegistrationData

    @State private var gotoOnboard = false
    @Environment(\.dismiss) var dismiss

    // Existing fields
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var dob = Date()
    @State private var password: String = ""
    
    // New fields
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var gender: String = ""
    
    
    @State private var statusMessage: String = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    // Top Navigation
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "arrow.left")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .font(.system(size: 20))
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 40)
                    
                    Text("Create Account")
                        .font(Font.custom("Roboto_condensed-black", size: 24))
                        .padding(.bottom, 15)
                    
                    // User Info Fields
                    Group {
                        TextField("Username", text: $registrationData.username)
                            .padding()
                            .background(Color.textBoxNavy)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .disableAutocorrection(true)
                            .colorScheme(.dark)
                            .padding(.horizontal, 25)
                            .padding(.bottom, 5)
                        
                        TextField("Email", text: $registrationData.email)
                            .padding()
                            .background(Color.textBoxNavy)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .disableAutocorrection(true)
                            .colorScheme(.dark)
                            .padding(.horizontal, 25)
                            .padding(.bottom, 5)
                        
                        TextField("Phone", text: $registrationData.phone)
                            .padding()
                            .background(Color.textBoxNavy)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .disableAutocorrection(true)
                            .colorScheme(.dark)
                            .padding(.horizontal, 25)
                            .padding(.bottom, 5)
                        
                        DatePicker("Date of Birth", selection: $registrationData.dob, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .padding()
                            .background(Color.textBoxNavy)
                            .foregroundColor(.white.opacity(0.5))
                            .cornerRadius(8)
                            .disableAutocorrection(true)
                            .colorScheme(.dark)
                            .padding(.horizontal, 25)
                            .padding(.bottom, 5)
    
                        SecureField("Password", text: $registrationData.password)
                            .padding()
                            .background(Color.textBoxNavy)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .disableAutocorrection(true)
                            .colorScheme(.dark)
                            .padding(.horizontal, 25)
                            .padding(.bottom, 5)
                    }
                    
                    // New Registration Fields
                    Group {
                        TextField("First Name", text: $registrationData.firstName)
                            .padding()
                            .background(Color.textBoxNavy)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .disableAutocorrection(true)
                            .colorScheme(.dark)
                            .padding(.horizontal, 25)
                            .padding(.bottom, 5)
                        
                        TextField("Last Name", text: $registrationData.lastName)
                            .padding()
                            .background(Color.textBoxNavy)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .disableAutocorrection(true)
                            .colorScheme(.dark)
                            .padding(.horizontal, 25)
                            .padding(.bottom, 5)
                       
                          
                    }
                    
                    // Registration Button
                    Button("Continue") {
                        /*
                        Task {
                            await registerUser()
                        }
                         */
                        gotoOnboard = true

                    }
                    .font(Font.custom("Roboto_Condensed-Black", size: 18))
                    .frame(width: 350, height: 55)
                    .background(Color.magenta)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .buttonStyle(BorderlessButtonStyle())
                    .padding(.bottom, 20)
                    
                    
                    // Display Status/Error Message
                    Text(statusMessage)
                        .foregroundColor(.red)
                        .padding(.horizontal, 25)
                        .padding(.bottom, 10)
                    
                    // Social Sign Up Buttons (Optional)
                    Button(action: {}) {
                        HStack {
                            Image("google")
                            ZStack {
                                Text("Sign up with Google")
                            }
                            .frame(maxWidth: .infinity)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                    }
                    .font(Font.custom("Roboto_Condensed-Black", size: 18))
                    .frame(width: 380, height: 42)
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .buttonStyle(BorderlessButtonStyle())
                    .padding(.top, -35)
                    
                    Button(action: {}) {
                        HStack {
                            Image("apple")
                            ZStack {
                                Text("Sign up with Apple")
                            }
                            .frame(maxWidth: .infinity)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                    }
                    .font(Font.custom("Roboto_Condensed-Black", size: 18))
                    .frame(width: 380, height: 42)
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .buttonStyle(BorderlessButtonStyle())
                    .padding(.top, 10)
                    
                    Text("By clicking signing up, you agree to our Terms of Service and Privacy Policy.")
                        .font(Font.custom("Roboto_Condensed-Black", size: 14))
                        .foregroundColor(Color.white)
                        .padding(.top, 10)
                    
                }
                .frame(maxWidth: .infinity)
            }
            .background(Color.navy)
            .navigationDestination(isPresented: $gotoOnboard) {
                OnboardingView()
                    .environmentObject(registrationData)
            }
            .padding(.top, -50)
        }
    }
    
    /*
    // MARK: - Register User
    /// Attempts to register a new user with all the provided fields.
    func registerUser() async {
        // Convert numeric fields
        guard let ageInt = Int(age),
              let weightDouble = Double(weight),
              let heightDouble = Double(height) else {
            statusMessage = "Please enter valid numbers for Age, Weight, and Height."
            return
        }
        
        do {
            let response = try await NetworkManager.shared.registerUser(
                username: username,
                password: password,
                firstName: firstName,
                lastName: lastName,
                dob: dob,
                email: email,
                phone: phone,
                gender: gender,
                age: ageInt,
                units: units,
                weight: weightDouble,
                height: heightDouble,
                goals: goals,
                bio: bio,
                role: role
            )
            
            if let registeredUsername = response["username"] as? String {
                statusMessage = "Registered user: \(registeredUsername)"
                gotoOnboard = true
            } else {
                statusMessage = "Unexpected response: \(response)"
            }
        } catch {
            statusMessage = "Registration failed: \(error.localizedDescription)"
        }
    }
     */
}

struct CreateAccountView_Preview: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
    }
}
