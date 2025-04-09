//
//  CreateAccount.swift
//  MoveMentorDraft
//
//  Created by Kaleb Lee on 3/11/25.
//

import SwiftUI


struct CreateAccountView: View {
    @EnvironmentObject var session: UserSession
    @StateObject private var registrationData = RegistrationData()
    @State private var gotoOnboard = false
    @Environment(\.dismiss) var dismiss
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var dob = Date()
    @State private var password: String = ""
    
    
    var body: some View{
        NavigationStack{
            GeometryReader{ geometry in
                VStack{
                    HStack{
                        Button(action: {dismiss()}){
                            Image(systemName: "arrow.left")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .font(.system(size: 20))
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 40)
                    
                    
                    Text("Create Account")
                        .font(Font.custom("Roboto_condensed-black", size: 24))
                        .padding(.bottom, 15)
                    
                    TextField("First Name", text: $firstName)
                        .padding()
                        .background(Color.textBoxNavy)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .disableAutocorrection(true)
                        .padding(.horizontal, 25)
                        .padding(.bottom, 5)
                    
                    TextField("Last Name", text: $lastName)
                        .padding()
                        .background(Color.textBoxNavy)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .disableAutocorrection(true)
                        .padding(.horizontal, 25)
                        .padding(.bottom, 5)
                    
                    TextField("Username", text: $username)
                        .padding()
                        .background(Color.textBoxNavy)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .disableAutocorrection(true)
                        .padding(.horizontal, 25)
                        .padding(.bottom, 5)
                    
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.textBoxNavy)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .disableAutocorrection(true)
                        .padding(.horizontal, 25)
                        .padding(.bottom, 5)
                    
                    TextField("Phone", text: $phone)
                        .padding()
                        .background(Color.textBoxNavy)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .disableAutocorrection(true)
                        .padding(.horizontal, 25)
                        .padding(.bottom, 5)
                    
                    DatePicker("Date of Birth", selection: $dob, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .padding()
                        .background(Color.textBoxNavy)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .disableAutocorrection(true)
                        .padding(.horizontal, 25)
                        .padding(.bottom, 5)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.textBoxNavy)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .disableAutocorrection(true)
                        .padding(.horizontal, 25)
                        .padding(.bottom, 20)
                    
                    Button("Continue"){
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd"
                        let dobString = formatter.string(from: dob)
                        
                        registrationData.firstName = firstName
                        registrationData.lastName = lastName
                        registrationData.username = username
                        registrationData.email = email
                        registrationData.phone = phone
                        registrationData.dob = dobString
                        registrationData.password = password
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            gotoOnboard = true
                        }
                    }
                    .font(Font.custom("Roboto_Condensed-Black", size: 18))
                    .frame(width: 350, height: 55)
                    .background(Color.magenta)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .buttonStyle(BorderlessButtonStyle())
                    .padding(.bottom, 20)
                    
                    Button(action: {}){
                        HStack{
                            Image("google")
                            ZStack{
                                Text("Sign up with Google")
                            }
                            .frame(maxWidth: .infinity)
                            
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            
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
                    
                    
                    Button(action: {}){
                        HStack{
                            Image("apple")
                            
                            ZStack{
                                Text("Sign up with Apple")
                            }
                            .frame(maxWidth: .infinity)
                            
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            
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
                }
                .frame(width: geometry.size.width)
                .padding(.top, -40)
            
            }
            
            .navigationDestination(isPresented: $gotoOnboard){
                OnboardingView(registrationData: registrationData)
            }
            
            .onAppear {
                print("👀 Progress_1_View sees: \(session.firstName) \(session.lastName)")
            }
        }
    }
}
    

struct CreateAccountView_Preview: PreviewProvider{
    static var previews: some View{
        CreateAccountView()
    }
}
