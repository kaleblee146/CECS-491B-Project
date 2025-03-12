//
//  Onboarding.swift
//  MoveMentorDraft
//
//  Created by Kaleb Lee on 3/11/25.
//

import SwiftUI


struct OnboardingView: View {
    @State private var goBack = false
    @State private var continueButton = false
    
    var body: some View{
        VStack{
            Text("Welcome to Onboarding")
            
            Text("Step One: The foundation to your fitness journey")
            
            Text("Movementor would like to ask you a few questions to better understand you and meet your needs")
            
            HStack{
                Button("BACK"){
                    goBack = true
                }
                .background(Color.blueMagenta)
                .padding()
                
                Button("CONTINUE"){
                    continueButton = true
                }
                .background(Color.magenta)
            }
            .padding(.top, 15)
            
        }
        .frame(width: 402, height: 869)
        .background(Color.navy)
        .navigationDestination(isPresented: $goBack){
            CreateAccountView()
        }
        .navigationDestination(isPresented: $continueButton){
            SurveyView1()
        }
        
    }
}

struct OnboardingView_Preview: PreviewProvider{
    static var previews: some View{
        OnboardingView()
    }
}


