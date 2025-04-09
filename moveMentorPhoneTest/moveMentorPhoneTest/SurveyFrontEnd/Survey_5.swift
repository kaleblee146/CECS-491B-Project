//
//  Survey_5.swift
//  MoveMentorDraft
//
//  Created by Kaleb Lee on 3/12/25.
//

import SwiftUI

struct SurveyView5: View {
    @EnvironmentObject var session: UserSession
    @ObservedObject var registrationData: RegistrationData
    
    @State private var heightFeet: String = ""
    @State private var heightInches: String = ""
    
    @State private var goBack = false
    @State private var continueButton = false
    @State private var showAlert = false
    
    var body: some View{
        NavigationStack{
            VStack{
                
                Text("What is your height?")
                    .font(Font.custom("Roboto_condensed-black", size: 18))
                    .padding(.bottom, 50)
                
                TextField("ft", text: $heightFeet )
                    .padding()
                    .background(Color.textBoxNavy)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disableAutocorrection(true)
                    .colorScheme(.dark)
                    .padding(.horizontal, 25)
                    
                
                TextField("in", text: $heightInches)
                    .padding()
                    .background(Color.textBoxNavy)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disableAutocorrection(true)
                    .colorScheme(.dark)
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
                        let feet = Double(heightFeet) ?? 0
                        let inches = Double(heightInches) ?? 0
                        let totalHeight = feet * 12 + inches
                        registrationData.height = totalHeight
                        
                        continueButton = true
                        
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
                SurveyView4(registrationData: registrationData)
                    .environmentObject(session)
            }
            .navigationDestination(isPresented: $continueButton){
                SurveyView6(registrationData: registrationData)
                    .environmentObject(session)
            }
            
        }
    }
}

struct SurveyView5_Previews: PreviewProvider {
    static var previews: some View {
        SurveyView5(registrationData: RegistrationData())
    }
}
