//
//  LoginFailView.swift
//  MoveMentorDraft
//
//  Created by Kaleb Lee on 3/10/25.
//


import SwiftUI

struct LoginView: View {
    @State private var signUp = false
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var loginMessage: String = ""
    
    // Test hard-coded password
    private let correctUsername = "Kaleb"
    private let correctPassword = "1234"
    
    var body: some View{
        NavigationStack{
            ZStack {
                Image("Login")
                    .resizable()
                    .scaledToFit()
                    .ignoresSafeArea()
                VStack{
                    VStack {
                        Rectangle()
                            .fill(Color.navy)
                            .frame(width: 328, height: 376)
                            
                            .overlay(
                                VStack(){
                                    Text("Welcome Back")
                                        .padding(.bottom, 25)
                                    Text("Login into your account")
                                    
                                    TextField("Username", text: $username)
                                        .padding()
                                        .background(Color.textBoxNavy)
                                        .foregroundColor(.black)
                                        .cornerRadius(8)
                                        .disableAutocorrection(true)
                                    SecureField("Password", text: $password)
                                        .padding()
                                        .background(Color.textBoxNavy)
                                        .foregroundColor(.black)
                                        .cornerRadius(8)
                                        .disableAutocorrection(true)
                                    
                                    Button(action: checkLogin){
                                        Text("Continue")
                                    }
                                    
                                    if !loginMessage.isEmpty{
                                    Text(loginMessage)
                                        .foregroundColor(loginMessage == "Login Successful" ? .green : .red)
                                    }
                                    
                                    Button(action: {}){
                                        HStack{
                                            Image(systemName: "globe")
                                            Text("Sign in with Google")
                                        }
                                    }
                                    
                                    
                                    Button(action: {}){
                                        HStack{
                                            Image(systemName: "applelogo")
                                            Text("Sign in with Apple")
                                        }
                                    }
                                    
                                    Button(action: {}){
                                        Text("Forgot Password?")
                                            .foregroundColor(Color.magenta)
                                            .underline()
                                        
                                    }
                                    .buttonStyle(BorderlessButtonStyle())
                                    
                                    HStack{
                                        Text("Don't have an account? ")
                                        Button("Sign up"){
                                            signUp = true
                                        }
                                        .foregroundColor(Color.magenta)
                                        .buttonStyle(BorderlessButtonStyle())
                                    }
                                    
                                }
                            )
                        
                        
                        
                    }
                    .offset(y: 150)
                    .navigationDestination(isPresented: $signUp){
                        CreateAccountView()
                    }
                }
            }
            
        }
            
    }
    private func checkLogin(){
        if username == correctUsername && password == correctPassword {
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

