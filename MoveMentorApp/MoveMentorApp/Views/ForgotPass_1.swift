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
                    Task {
                        await checkEmail()
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
                ForgotPass_2(email: email)
            }
            .navigationDestination(isPresented: $cancel){
                LoginView()
            }
        }
        
    }
    private func checkEmail() async {
            guard let url = URL(string: "http://192.168.1.18:8000/api/users/request-password-reset/") else {
                emailMessage = "Invalid URL"
                emailMatch = false
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let body = ["email": email]
            request.httpBody = try? JSONEncoder().encode(body)

            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                let decoded = try? JSONDecoder().decode([String: String].self, from: data)

                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    emailMatch = true
                    emailMessage = decoded?["message"] ?? "Verification code sent!"
                    goNext = true
                } else {
                    emailMatch = false
                    emailMessage = decoded?["error"] ?? "Something went wrong."
                }
            } catch {
                emailMatch = false
                emailMessage = "Network error. Try again later."
            }
        }
    }


    

struct ForgotPass1Preview: PreviewProvider{
    static var previews: some View{
        ForgotPass_1()
    }
}
