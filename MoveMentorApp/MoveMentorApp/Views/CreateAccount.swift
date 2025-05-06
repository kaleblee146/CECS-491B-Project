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
    
    @State private var showUsernameError = false
    @State private var showEmailError = false
    @State private var showPhoneError = false
    @State private var showDOBError = false
    @State private var showPasswordError = false
    @State private var showFirstNameError = false
    @State private var showLastNameError = false
    
    
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
                        if showUsernameError {
                            errorText("Username is required.")
                        }
                        
                        TextField("Email", text: $registrationData.email)
                            .padding()
                            .background(Color.textBoxNavy)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .disableAutocorrection(true)
                            .colorScheme(.dark)
                            .padding(.horizontal, 25)
                            .padding(.bottom, 5)
                        if showEmailError {
                            errorText("Email is required.")
                        }
                        
                        
                        TextField("Phone", text: $registrationData.phone)
                            .padding()
                            .background(Color.textBoxNavy)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .disableAutocorrection(true)
                            .colorScheme(.dark)
                            .padding(.horizontal, 25)
                            .padding(.bottom, 5)
                        if showPhoneError {
                            errorText("Phone is required.")
                        }
                        
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
                        if showDOBError {
                            errorText("Please enter a valid birthdate (13+ years old).")
                        }
    
                        SecureField("Password", text: $registrationData.password)
                            .padding()
                            .background(Color.textBoxNavy)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .disableAutocorrection(true)
                            .colorScheme(.dark)
                            .padding(.horizontal, 25)
                            .padding(.bottom, 5)
                        if showPasswordError {
                            errorText("Password is required (at least 8 Characters).")
                        }
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
                        if showFirstNameError {
                            errorText("First Name is required.")
                        }
                        
                        TextField("Last Name", text: $registrationData.lastName)
                            .padding()
                            .background(Color.textBoxNavy)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .disableAutocorrection(true)
                            .colorScheme(.dark)
                            .padding(.horizontal, 25)
                            .padding(.bottom, 5)
                        if showLastNameError {
                            errorText("Last Name is required.")
                        }
                       
                          
                    }
                    
                    // Registration Button
                    Button("Continue") {
                        /*
                        Task {
                            await registerUser()
                        }
                         */
                        validateAndProceed()
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
    
    func validateAndProceed() {
            let today = Date()
            let calendar = Calendar.current
            let ageComponents = calendar.dateComponents([.year], from: registrationData.dob, to: today)
            let age = ageComponents.year ?? 0

            showUsernameError = registrationData.username.isEmpty
            showEmailError = !registrationData.email.contains("@")
            showPhoneError = registrationData.phone.isEmpty
            showPasswordError = registrationData.password.count < 6
            showFirstNameError = registrationData.firstName.isEmpty
            showLastNameError = registrationData.lastName.isEmpty
            showDOBError = registrationData.dob > today || age < 13



        let hasError = showUsernameError || showEmailError || showPhoneError || showPasswordError || showFirstNameError || showLastNameError || showDOBError


            if !hasError {
                gotoOnboard = true
            }
        }
    
    func errorText(_ message: String) -> some View {
            Text(message)
                .font(.caption)
                .foregroundColor(.red)
                .padding(.horizontal, 25)
                .padding(.bottom, 5)
                .frame(maxWidth: .infinity, alignment: .leading)
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
