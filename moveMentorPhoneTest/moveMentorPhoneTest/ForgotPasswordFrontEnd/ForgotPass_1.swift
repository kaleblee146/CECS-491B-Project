//
//  ForgotPass_1.swift
//  MoveMentorDraft
//
//  Created by Kaleb Lee on 3/18/25.
//

import SwiftUI

struct ForgotPass_1: View{
    @EnvironmentObject var session: UserSession
    @State private var email: String = ""
    
    @State private var goNext = false
    @State private var cancel = false
    
    @State var emailMatch = false
    @State private var emailMessage = ""
    
   
    
    
    
    var body: some View{
        NavigationStack{
            GeometryReader{ geometry in
                VStack{
                    Text("Reset your password")
                        .font(Font.custom("Roboto_Condensed-Black", size: 18))
                        .foregroundColor(Color.white)
                        .padding(.bottom, 50)
                    
                    Text("Please enter email used to register")
                        .font(Font.custom("Roboto_Condensed-Black", size: 18))
                        .foregroundColor(Color.white)
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
                .frame(width: geometry.size.width)
                .padding(.top, 70)
                
            }
            
            .background(Color.navy)
            .navigationDestination(isPresented: $goNext){
                ForgotPass_2(email: email)
            }
            .navigationDestination(isPresented: $cancel){
                LoginView(session: session)
            }
        }
        
    }
    private func checkEmail(){
        guard let url = URL(string: "http://127.0.0.1:8000/api/users/request-password-reset/") else {
            print("Invalid URL")
            return
        }
        
        let payload = ["email": email]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: payload) else {
            print("Failed to encode JSON")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async{
                if let error = error {
                    print("Request failed: \(error)")
                    emailMatch = false
                    emailMessage = "Something went wrong. Try Again."
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse{
                    if httpResponse.statusCode == 200 {
                        emailMatch = true
                        goNext = true
                    } else if httpResponse.statusCode == 404{
                        emailMatch = false
                        emailMessage = "The email entered does not match any email in our database."
                    } else {
                        emailMatch = false
                        emailMessage = "Unexpected Error: \(httpResponse.statusCode)"
                    }
                }
            }
            
            
            
            
        }.resume()
    }
}

    

struct ForgotPass1Preview: PreviewProvider{
    static var previews: some View{
        ForgotPass_1()
    }
}
