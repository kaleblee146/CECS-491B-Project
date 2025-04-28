//
//  LoginView.swift
//  MoveMentorDraft
//
//  Created by Kaleb Lee on 3/10/25.
//  Modified by Chase Sansom on 4/6/25.

import SwiftUI

struct LoginView: View {
    @State private var signUp = false
    @State private var correctPass = false
    @State private var forgotPass = false
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var loginMessage: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("Login")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 250)
                    .ignoresSafeArea(edges: .top)
                
                Text("Welcome Back")
                    .font(.system(size: 38))
                    .padding(.bottom, 5)
                
                Text("Login into your account")
                    .font(.system(size: 18))
                    .padding(.bottom, 10)
                
                TextField("Username", text: $username)
                    .padding()
                    .background(Color.textBoxNavy)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disableAutocorrection(true)
                    .colorScheme(.dark)
                    .padding(.horizontal, 25)
                    .padding(.bottom, 10)
                    .textInputAutocapitalization(.never)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.textBoxNavy)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disableAutocorrection(true)
                    .colorScheme(.dark)

                    .padding(.horizontal, 25)
                    .padding(.bottom, 10)
                    .textInputAutocapitalization(.never)
                
                Button(action: {
                    Task {
                        await performLogin()
                    }
                }) {
                    Text("Continue")
                }
                .font(Font.custom("Roboto_Condensed-Black", size: 18))
                .frame(width: 350, height: 55)
                .background(Color.magenta)
                .foregroundColor(.white)
                .cornerRadius(10)
                .buttonStyle(BorderlessButtonStyle())
                .padding(.bottom, 10)
                .navigationDestination(isPresented: $correctPass) {
                    Progress_1_View()
                }
                
                if !loginMessage.isEmpty {
                    Text(loginMessage)
                        .foregroundColor(loginMessage == "Login Successful!" ? .green : .red)
                        .padding(.bottom, 10)
                }
                
                Button(action: {}) {
                    HStack {
                        Image("google")
                        Text("Sign in with Google")
                            .frame(maxWidth: .infinity)
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
                
                Button(action: {}) {
                    HStack {
                        Image("apple")
                        Text("Sign in with Apple")
                            .frame(maxWidth: .infinity)
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
                
                Button(action: {
                    forgotPass = true
                }) {
                    Text("Forgot Password?")
                        .foregroundColor(Color.magenta)
                        .underline()
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(.top, 15)
                .navigationDestination(isPresented: $forgotPass) {
                    ForgotPass_1()
                }
                
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.white)
                    Button("Sign up") {
                        signUp = true
                    }
                    .foregroundColor(Color.magenta)
                    .buttonStyle(BorderlessButtonStyle())
                }
                .padding(.top, 10)
                .navigationDestination(isPresented: $signUp) {
                    CreateAccountView()
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.navy)
        }
    }
    
    // MARK: - Perform Login
    /// Uses the NetworkManager to attempt login with the provided username and password.
    private func performLogin() async {
        do {
            let response = try await NetworkManager.shared.loginUser(username: username, password: password)
            
            // Example: Check if the response includes an access token.
            if let accessToken = response["access"] as? String {
                loginMessage = "Login Successful!"
                correctPass = true
                // Optionally, store the access token securely (e.g., in Keychain)
            } else {
                loginMessage = "Unexpected response: \(response)"
            }
        } catch let error as NetworkError {
            switch error {
            case .invalidURL:
                loginMessage = "Invalid URL"
            case .badStatusCode(let code):
                loginMessage = "Server returned status code \(code)."
            case .parsingError:
                loginMessage = "Failed to parse JSON response."
            }
        } catch {
            loginMessage = "Login failed: \(error.localizedDescription)"
        }
    }
}

struct LoginViewPreview: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
