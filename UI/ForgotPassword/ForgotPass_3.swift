//
//  ForgotPass_3.swift
//  MoveMentorDraft
//
//  Created by Kaleb Lee on 3/18/25.
//

import SwiftUI

struct ForgotPass_3: View{
    var email: String
    var code: String
    
    @State private var newPass: String = ""
    @State private var confirmNew: String = ""
    
    @State private var goNext = false
    @State private var cancel = false
    
    @State private var passMatch = false
    @State private var passMessage = ""
    
   
    
    
    var body: some View{
        NavigationStack{
            VStack{
                Text("Reset your password")
                    .font(Font.custom("Roboto_Condensed-Black", size: 18))
                    .padding(.bottom, 50)
                
                SecureField("New Password", text: $newPass)
                    .font(Font.custom("Roboto_Condensed-Black", size: 18))
                    .frame(width: 347, height: 55)
                    .padding()
                    .background(Color.textBoxNavy)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disableAutocorrection(true)
                    .padding(.horizontal, 25)
                
                SecureField("Confirm New Password", text: $confirmNew)
                    .font(Font.custom("Roboto_Condensed-Black", size: 18))
                    .frame(width: 347, height: 55)
                    .padding()
                    .background(Color.textBoxNavy)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disableAutocorrection(true)
                    .padding(.horizontal, 25)
                
                if !passMessage.isEmpty{
                    Text(passMessage)
                        .foregroundColor(passMatch ? .green : .red)
                }
                
                Button("CONTINUE"){
                    checkPass()
                    
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
                PasswordChangeSuccess()
            }
            .navigationDestination(isPresented: $cancel){
                ForgotPass_2(email: email)
            }
            
        }
        
    }
    private func checkPass() {
        guard newPass == confirmNew else {
            passMatch = false
            passMessage = "The passwords do not match."
            return
        }

        guard let url = URL(string: "http://127.0.0.1:8000/api/users/confirm-password-reset/") else {
            print("Invalid URL")
            return
        }

        let payload = [
            "email": email,
            "code": code,
            "new_password": newPass
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: payload) else {
            print("Failed to encode JSON")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    passMatch = false
                    passMessage = "Something went wrong: \(error.localizedDescription)"
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        passMatch = true
                        goNext = true
                        
                    } else {
                        passMatch = false
                        passMessage = "Unable to update password. Try again."
                    }
                }
            }
        }.resume()
    }
    

}

