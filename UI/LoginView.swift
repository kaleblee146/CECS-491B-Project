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
            VStack(spacing: 0) {
                        Image("Login")
                            .resizable()
                            .scaledToFill()
                            .frame(height: 250)
                            .ignoresSafeArea(edges: .top)
                        
                        Text("Welcome Back")
                            .font(.system(size: 38))
                            
                        Text("Login into your account")
                            .font(.system(size: 18))
                            
                    
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
                        
                        }
                        HStack{
                            Text("Don't have an account?")
                            Button("Sign up"){
                                signUp = true
                            }
                            .foregroundColor(Color.magenta)
                            .buttonStyle(BorderlessButtonStyle())
                        }
                }
     
                    .navigationDestination(isPresented: $signUp){
                        CreateAccountView()
                    
                }
            
                .frame(width: 402, height: 869)
                .background(Color.navy)
                
            
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

