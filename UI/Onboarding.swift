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
        VStack {
            
            Text("Welcome to Onboarding")
                .font(.system(size: 18))
                .padding(.top, 170)
    
            Text("Step One: ")
                .font(.system(size: 16))
                .padding(.top, 28)
            
            Text("The Foundation to ")
                .font(.system(size: 16))
            
            Text("Your Fitness Journey")
                .font(.system(size: 16))
            
            Text("Movementor would like to ask you a few")
                .font(.system(size: 16))
                .padding(.top, 144)
            
            Text("questions to better understand you and meet")
                .font(.system(size: 16))
            
            Text("your needs.")
                .font(.system(size: 16))
                
            
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
            
            /*
             .font(Font.custom("Roboto_Condensed-Black", size: 18))
             .frame(width: 350, height: 50)
             .background(Color.magenta)
             .foregroundColor(.white)
             .cornerRadius(25)
             .padding(.bottom, 50)
             .buttonStyle(BorderlessButtonStyle())
             */
            
        }
        .frame(width: 402, height: 869, alignment: .top)
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


