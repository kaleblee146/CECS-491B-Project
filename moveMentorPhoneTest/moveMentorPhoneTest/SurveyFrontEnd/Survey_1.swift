//
//  Survey_1.swift
//  MoveMentorDraft
//
//  Created by Kaleb Lee on 3/11/25.
//

import SwiftUI

struct SurveyView1: View {
    @EnvironmentObject var session: UserSession
    @ObservedObject var registrationData: RegistrationData
    
    @State private var goBack = false
    @State private var continueButton = false
    @State private var selectedImage: Int? = nil
    @State private var localGender: String = ""
    @State private var showAlert = false

    
    var body: some View{
        NavigationStack{
            VStack{
                Text("Male or Female?")
                    .font(Font.custom("Roboto_condensed-black", size: 18))
                    .padding(.bottom, 15)
                
                Text("Select your sex")
                    .font(Font.custom("Roboto_condensed-black", size: 18))
                    .foregroundColor(.gray)
                    .padding(.bottom, 30)
                
                
                HStack{
                    Image("Male")
                        .brightness(selectedImage == 1 ? 0 : -0.3)
                        .onTapGesture{
                            selectedImage = (selectedImage == 1) ? nil : 1
                            localGender = "Male"
                        }
                        
                    Image("Female")
                        .brightness(selectedImage == 2 ? 0 : -0.3)
                        .onTapGesture{
                            selectedImage = (selectedImage == 2) ? nil : 2
                            localGender = "Female"
                        }
                }
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
                        if localGender.isEmpty{
                            showAlert = true
                        } else {
                            registrationData.gender = localGender
                            continueButton = true
                        }
                       
                    }
                    .font(Font.custom("Roboto_Condensed-Black", size: 18))
                    .frame(width: 164, height: 60)
                    .background(Color.magenta)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .buttonStyle(BorderlessButtonStyle())
                    .padding()
                }
                .padding(.top, 250)
            }
            .frame(width: 402, height: 869)
            .background(Color.navy)
            .navigationDestination(isPresented: $goBack){
                OnboardingView(registrationData: registrationData)
            }
            .navigationDestination(isPresented: $continueButton){
                SurveyView2(registrationData: registrationData)
                    .environmentObject(session)
            }
            .alert("Please select a gender to continue", isPresented: $showAlert){
                Button("OK", role: .cancel) {}
            }
        }
    }
}

struct SurveyView_Previews: PreviewProvider {
    static var previews: some View {
        SurveyView1(registrationData: RegistrationData())
    }
}

