//
//  Survey_1.swift
//  MoveMentorDraft
//
//  Created by Kaleb Lee on 3/11/25.
//

import SwiftUI

struct SurveyView1: View {
    @State private var goBack = false
    @State private var continueButton = false
    @State var selectedImage: Int? = nil
    
    
    var body: some View{
        NavigationStack{
            VStack{
                Text("Male or Female?")
                Text("Select your sex")
                
                HStack{
                    Image("Male")
                        .brightness(selectedImage == 1 ? 0 : -0.3)
                        .onTapGesture{
                            selectedImage = (selectedImage == 1) ? nil : 1
                        }
                    Image("Female")
                        .brightness(selectedImage == 2 ? 0 : -0.3)
                        .onTapGesture{
                            selectedImage = (selectedImage == 2) ? nil : 2
                        }
                }
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
                OnboardingView()
            }
            .navigationDestination(isPresented: $continueButton){
                SurveyView2()
            }
        }
    }
}

struct SurveyView_Previews: PreviewProvider {
    static var previews: some View {
        SurveyView1()
    }
}

