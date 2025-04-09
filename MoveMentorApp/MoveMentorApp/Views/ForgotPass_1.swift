//
//  ForgotPass_1.swift
//  MoveMentorDraft
//
//  Created by Kaleb Lee on 3/18/25.
//

import SwiftUI

struct ForgotPass_1: View{
    @State private var email: String = ""
    
    @State private var goNext = false
    @State private var cancel = false
    
    @State var emailMatch = false
    @State private var emailMessage = ""
    
    private let exampleEmail = "username@gmail.com"
    
    var body: some View{
        NavigationStack{
            VStack{
                
                Text("Reset your password")
                    .font(Font.custom("Roboto_Condensed-Black", size: 18))
                    .padding(.bottom, 50)
                
                Text("Please enter email used to register")
                    .font(Font.custom("Roboto_Condensed-Black", size: 18))
                    .padding(.bottom, 120)
                
                TextField("Email", text: $email)
                    .font(Font.custom("Roboto_Condensed-Black", size: 18))
                    .frame(width: 347, height: 55)
                    .padding()
                    .background(Color.textBoxNavy)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disableAutocorrection(true)
                    .padding(.horizontal, 25)
                    
                
                if !emailMessage.isEmpty{
                    Text(emailMessage)
                        .foregroundColor(emailMatch ? .green : .red)
                }
                
                
                Button("CONTINUE"){
                    checkEmail()
                    if emailMatch{
                        goNext = true
                    }
                }
                .font(Font.custom("Roboto_Condensed-Black", size: 18))
                .frame(width: 347, height: 55)
                .background(Color.magenta)
                .foregroundColor(.white)
                .cornerRadius(10)
                .buttonStyle(BorderlessButtonStyle())
                .padding(.top, 50)
                .padding()
                
                
                Button("CANCEL"){
                    cancel = true
                }
                .font(Font.custom("Roboto_Condensed-Black", size: 18))
                .frame(width: 347, height: 55)
                .background(Color.blueMagenta)
                .foregroundColor(.white)
                .cornerRadius(10)
                .buttonStyle(BorderlessButtonStyle())
                
                
                
            }
            .frame(width: 402, height: 869)
            .background(Color.navy)
            .navigationDestination(isPresented: $goNext){
                ForgotPass_2()
            }
            .navigationDestination(isPresented: $cancel){
                LoginView()
            }
        }
        
    }
    private func checkEmail(){
        if email == exampleEmail{
            emailMatch = true
            
        } else {
            emailMatch = false
            emailMessage = "The email entered does not match any email in our database"
        }
    }
}

    

struct ForgotPass1Preview: PreviewProvider{
    static var previews: some View{
        ForgotPass_1()
    }
}
