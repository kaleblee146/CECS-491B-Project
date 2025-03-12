//
//  CreateAccount.swift
//  MoveMentorDraft
//
//  Created by Kaleb Lee on 3/11/25.
//

import SwiftUI


struct CreateAccountView: View {
    @State private var gotoOnboard = false
    
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var dob: String = ""
    @State private var password: String = ""
    
    
    var body: some View{
        NavigationStack{
            VStack{
                Text("Create Account")
                
                TextField("Username", text: $username)
                
                TextField("Email", text: $email)
                
                TextField("Phone", text: $phone)
                
                TextField("Date of Birth", text: $dob)
                
                TextField("Password", text: $password)
                
                Button("Continue"){
                    gotoOnboard = true
                }
                
                Button(action: {}){
                    HStack{
                        Image(systemName: "globe")
                        Text("Sign up with Google")
                    }
                }
                
                
                Button(action: {}){
                    HStack{
                        Image(systemName: "applelogo")
                        Text("Sign up with Apple")
                    }
                }

                Text("By clicking Continue, you agree to the following terms and conditions without reservation")
                
            }
            .frame(width: 402, height: 869)
            .background(Color.navy)
            .navigationDestination(isPresented: $gotoOnboard){
                OnboardingView()
            }
        }
    }
}

struct CreateAccountView_Preview: PreviewProvider{
    static var previews: some View{
        CreateAccountView()
    }
}
