//
//  Survey_2.swift
//  MoveMentorDraft
//
//  Created by Kaleb Lee on 3/11/25.
//

import SwiftUI

struct SurveyView2: View {
    @EnvironmentObject var registrationData: RegistrationData

    @State private var selectedAge = 0
    
    @State private var goBack = false
    @State private var continueButton = false
    
    
    var body: some View {
        NavigationStack{
            VStack{
                Text("What's your age")
                    .font(Font.custom("Roboto_condensed-black", size: 18))
                    .padding(.bottom, 50)
                Picker("", selection: $selectedAge){
                    ForEach(0..<100, id: \.self) {
                        age in
                        Text("\(age)").tag(age)
                    }
                }
                .pickerStyle(.menu)
                //pickerStyle(.wheel)
                
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
                        registrationData.age = selectedAge
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.navy)
            .navigationDestination(isPresented: $goBack){
                SurveyView1()
            }
            .navigationDestination(isPresented: $continueButton){
                SurveyView3()
            }
        }
    }
    
}

struct SurveyView2_Previews: PreviewProvider {
    static var previews: some View {
        SurveyView2()
    }
}


