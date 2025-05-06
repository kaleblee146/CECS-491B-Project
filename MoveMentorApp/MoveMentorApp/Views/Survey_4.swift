//
//  Survey_4.swift
//  MoveMentorDraft
//
//  Created by Kaleb Lee on 3/12/25.
//

import SwiftUI

struct SurveyView4: View {
    @EnvironmentObject var registrationData: RegistrationData

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
                    .colorScheme(.dark)
                    .padding(.horizontal, 25)
                    .padding(.bottom, 100)
                    
                Spacer()
                
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
                        if let weightDouble = Double(setWeight), weightDouble > 0 {
                            registrationData.weight = weightDouble
                            continueButton = true
                        } else {
                            showAlert = true
                        }                    }
                    .font(Font.custom("Roboto_Condensed-Black", size: 18))
                    .frame(width: 164, height: 60)
                    .background(Color.magenta)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .buttonStyle(BorderlessButtonStyle())
                    .padding()
                }
                .padding(.bottom, 40)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.navy)
            .navigationDestination(isPresented: $goBack){
                SurveyView3()
            }
            .navigationDestination(isPresented: $continueButton){
                SurveyView5()
            }
            .alert("⚖️ Invalid Weight", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please enter a valid number greater than 0 for your weight.")
            }
        }
    }
}

struct SurveyView4_Previews: PreviewProvider {
    static var previews: some View {
        SurveyView4()
    }
}
