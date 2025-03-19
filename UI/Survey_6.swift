//
//  Survey_6.swift
//  MoveMentorDraft
//
//  Created by Kaleb Lee on 3/12/25.
//

import SwiftUI

struct SurveyView6: View {
    @State private var goBack = false
    @State private var continueButton = false
    
    @State private var goal1: String = ""
    @State private var goal2: String = ""
    @State private var goal3: String = ""
    @State private var goal4: String = ""
    @State private var goal5: String = ""
    
    
    var body: some View{
        NavigationStack{
            VStack{
                Text("Describe your fitness goals")
                    .font(Font.custom("Roboto_condensed-black", size: 18))
                    .padding(.bottom, 50)
                
                TextField("1. ", text: $goal1)
                    .padding()
                    .background(Color.textBoxNavy)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disableAutocorrection(true)
                    .padding(.horizontal, 25)
                TextField("2. ", text: $goal2)
                    .padding()
                    .background(Color.textBoxNavy)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disableAutocorrection(true)
                    .padding(.horizontal, 25)
                TextField("3. ", text: $goal3)
                    .padding()
                    .background(Color.textBoxNavy)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disableAutocorrection(true)
                    .padding(.horizontal, 25)
                TextField("4. ", text: $goal4)
                    .padding()
                    .background(Color.textBoxNavy)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disableAutocorrection(true)
                    .padding(.horizontal, 25)
                TextField("5. ", text: $goal5)
                    .padding()
                    .background(Color.textBoxNavy)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disableAutocorrection(true)
                    .padding(.horizontal, 25)
                
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
                SurveyView5()
            }
            .navigationDestination(isPresented: $continueButton){
                SurveyView7()
            }
        }
    }
}

struct SurveyView6_Previews: PreviewProvider {
    static var previews: some View {
        SurveyView6()
    }
}
