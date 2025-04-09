//
//  ForgotPass_2.swift
//  MoveMentorDraft
//
//  Created by Kaleb Lee on 3/18/25.
//

import SwiftUI

struct ForgotPass_2: View{
    var email: String
    @State private var goNext = false
    @State private var cancel = false
    
    @State private var verifCode: String = ""
    @State private var verifMatch = false
    @State private var verifMessage = ""
    
    
    var body: some View{
        NavigationStack{
            VStack{
                
                Text("Reset your password")
                    .font(Font.custom("Roboto_Condensed-Black", size: 18))
                    .padding(.bottom, 50)
                
                Text("Enter the 6-digit verification code sent to ******@gmail.com")
                    .font(Font.custom("Roboto_Condensed-Black", size: 18))
                    .padding(.bottom, 120)
                
                TextField("Verification Code", text: $verifCode)
                    .font(Font.custom("Roboto_Condensed-Black", size: 18))
                    .frame(width: 347, height: 55)
                    .padding()
                    .background(Color.textBoxNavy)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disableAutocorrection(true)
                    .padding(.horizontal, 25)
                
                if !verifMessage.isEmpty{
                    Text(verifMessage)
                        .foregroundColor(verifMatch ? .green : .red)
                }

                
                Button("CONTINUE"){
                    checkVerif()
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
                ForgotPass_3(email: email, code: verifCode)
            }
            .navigationDestination(isPresented: $cancel){
                ForgotPass_1()
            }
               
                
                
                
            }
            
        }
    private func checkVerif() {
        guard let url = URL(string: "http://127.0.0.1:8000/api/users/confirm-password-reset/") else {
            print("Invalid URL")
            return
        }

        let payload = [
            "email": email,
            "code": verifCode,
            "new_password": "TempPass123"
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
                    print("Network error: \(error)")
                    verifMatch = false
                    verifMessage = "Something went wrong. Try again."
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        verifMatch = true
                        verifMessage = ""
                        goNext = true 
                    } else {
                        verifMatch = false
                        verifMessage = "The verification code entered is incorrect."
                    }
                }
            }
        }.resume()
    }

        
    }


