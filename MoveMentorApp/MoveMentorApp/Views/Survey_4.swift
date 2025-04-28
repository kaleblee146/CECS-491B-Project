//
//  Survey_4.swift
//  MoveMentorDraft
//
//  Created by Kaleb Lee on 3/12/25.
//

import SwiftUI

struct SurveyView4: View {
    @State private var setWeight: String = ""
    
    @State private var goBack = false
    @State private var continueButton = false
    
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.navy)
            .navigationDestination(isPresented: $goBack){
                SurveyView3()
            }
            .navigationDestination(isPresented: $continueButton){
                SurveyView5()
            }
        }
    }
}

struct SurveyView4_Previews: PreviewProvider {
    static var previews: some View {
        SurveyView4()
    }
}
