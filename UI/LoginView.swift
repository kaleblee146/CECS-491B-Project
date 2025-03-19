//
//  LoginFailView.swift
//  MoveMentorDraft
//
//  Created by Kaleb Lee on 3/10/25.
//

import SwiftUI

struct LoginView: View {
    @State private var signUp = false
    @State private var correctPass = false
    @State private var forgotPass = false
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var loginMessage: String = ""
    
    private let correctUsername = "kaleb"
    private let correctPassword = "1234"
    
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
                    .padding(.horizontal, 25)
                    .padding(.bottom, 10)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.textBoxNavy)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disableAutocorrection(true)
                    .padding(.horizontal, 25)
                    .padding(.bottom, 10)
                
                Button(action: checkLogin) {
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
            .frame(width: 402, height: 869)
            .background(Color.navy)
        }
    }
    

    private func checkLogin() {
        if username == correctUsername && password == correctPassword {
            correctPass = true
            loginMessage = "Login Successful!"
        } else {
            loginMessage = "Incorrect username or password"
        }
    }
}

struct LoginViewPreview: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
