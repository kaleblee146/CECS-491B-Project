//
//  UserSurveyFinale.swift
//  moveMentorPhoneTest
//
//  Created by Kaleb Lee on 4/4/25.
//

import SwiftUI

struct UserSurveyFinale: View {
    @ObservedObject var registrationData: RegistrationData
    @EnvironmentObject var session: UserSession
    @StateObject private var registrationAuth: RegisterAuthViewModel
    
    init(registrationData: RegistrationData, session: UserSession){
        self.registrationData = registrationData
        self._registrationAuth = StateObject(wrappedValue: RegisterAuthViewModel(session: session))
    }
     
    @State private var goBack = false
    @State private var continueButton = false
    
    var body: some View{
        NavigationStack{
            VStack{
                Text("Good job on completing your workout profile!")
                    .font(Font.custom("Roboto_condensed-black", size: 18))
                    .foregroundColor(Color.white)
                    .padding(.bottom, 50)
                
                Text("Tap 'Continue' below to create your account and get started")
                    .font(Font.custom("Roboto_condensed-black", size: 18))
                    .foregroundColor(Color.white)

                    
                HStack{
                    Button("BACK"){
                        goBack = true
                    }
                    .font(Font.custom("Roboto_Condensed-Black", size: 18))
                    .frame(width: 164, height: 60)
                    .background(Color.blueMagenta)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .buttonStyle(BorderlessButtonStyle())
                    .padding()
                    

                    Button("CONTINUE"){
                        let user = RegisterRequest(
                            firstName: registrationData.firstName, lastName: registrationData.lastName, username: registrationData.username, email: registrationData.email, phone: registrationData.phone, dob: registrationData.dob, password: registrationData.password,
                            role: "Free", gender: registrationData.gender, age: registrationData.age, units: registrationData.units, weight: registrationData.weight, height: registrationData.height, goals: registrationData.goals
                        )
                        registrationAuth.register(user: user)
                        
                        
                    }
                    .font(Font.custom("Roboto_Condensed-Black", size: 18))
                    .frame(width: 164, height: 60)
                    .background(Color.magenta)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .buttonStyle(BorderlessButtonStyle())
                    .padding()
                }
                .padding(.top, 200)
                    
            }
            .frame(width: 402, height: 869)
            .background(Color.navy)
            .navigationDestination(isPresented: $goBack){
                SurveyView6(registrationData: registrationData)
                    .environmentObject(session)
            }
            .navigationDestination(isPresented: $continueButton){
                SurveyView7(registrationData: registrationData)
                    .environmentObject(session)
            }
            .onChange(of: registrationAuth.isAuthenticated) { _, newValue in
                if newValue {
                    continueButton = true
                }
            }
        }
    }
}

struct UserSurveyFinalePreviews: PreviewProvider {
    static var previews: some View {
        UserSurveyFinale(registrationData: RegistrationData(), session: UserSession())
            .environmentObject(UserSession())
    }
}
