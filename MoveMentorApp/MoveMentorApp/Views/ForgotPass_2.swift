//
//  ForgotPass_2.swift
//  MoveMentorDraft
//
//  Created by Kaleb Lee on 3/18/25.
//

import SwiftUI

struct ForgotPass_2: View{
    let email: String
    
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
                    Task {
                        await checkVerifCode()
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
                ForgotPass_3(email: email, code: verifCode)
            }
            .navigationDestination(isPresented: $cancel){
                ForgotPass_1()
            }
               
                
    
                
            }
            
        }
        private func obscuredEmail(_ email: String) -> String {
            guard let atIndex = email.firstIndex(of: "@") else { return email }
            let prefix = email.prefix(upTo: atIndex)
            return "\(prefix.prefix(2))****@\(email.suffix(from: atIndex))"
        }

        private func checkVerifCode() async {
            guard let url = URL(string: "http://192.168.1.18:8000/api/usersconfirm-password-reset/") else {
                verifMessage = "Invalid URL"
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let body: [String: String] = [
                "email": email,
                "code": verifCode,
                "new_password": "placeholder"  // Required but ignored here
            ]
            request.httpBody = try? JSONEncoder().encode(body)

            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                let decoded = try? JSONDecoder().decode([String: String].self, from: data)

                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 400 {
                    verifMatch = false
                    verifMessage = decoded?["error"] ?? "Incorrect code."
                } else {
                    verifMatch = true
                    verifMessage = "Code verified!"
                    goNext = true
                }
            } catch {
                verifMatch = false
                verifMessage = "Network error. Try again later."
            }
        }
    }


