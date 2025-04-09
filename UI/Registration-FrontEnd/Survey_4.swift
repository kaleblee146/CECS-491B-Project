//
//  Survey_4.swift
//  MoveMentorDraft
//
//  Created by Kaleb Lee on 3/12/25.
//

import SwiftUI

struct SurveyView4: View {
    @EnvironmentObject var session: UserSession
    @ObservedObject var registrationData: RegistrationData
    
    @State private var setWeight: String = ""
    
    @State private var goBack = false
    @State private var continueButton = false
    @State private var showAlert = false
    
    var body: some View{
        NavigationStack{
            VStack{
                Text("What is your weight?")
                    .font(Font.custom("Roboto_Condensed-Black", size: 18))
                    .padding(.bottom, 50)
                
                TextField("Ibs", text: $setWeight)
                    .padding()
                    .background(Color.textBoxNavy)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disableAutocorrection(true)
                    .padding(.horizontal, 25)
                    .padding(.bottom, 100)
                    
                
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
                        if let weightValue = Double(setWeight){
                            registrationData.weight = weightValue
                            continueButton = true
                        } else {
                            showAlert = true
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
                SurveyView3(registrationData: registrationData)
                    .environmentObject(session)
            }
            .navigationDestination(isPresented: $continueButton){
                SurveyView5(registrationData: registrationData)
                    .environmentObject(session)
            }
            .alert("Please enter a valid number for weight", isPresented: $showAlert){
                Button("OK", role: .cancel) {}
            }
        }
    }
}

struct SurveyView4_Previews: PreviewProvider {
    static var previews: some View {
        SurveyView4(registrationData: RegistrationData())
    }
}
