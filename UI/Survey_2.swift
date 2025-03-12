//
//  Survey_2.swift
//  MoveMentorDraft
//
//  Created by Kaleb Lee on 3/11/25.
//

import SwiftUI

struct SurveyView2: View {
    @State private var selectedAge = 0
    
    @State private var goBack = false
    @State private var continueButton = false
    
    
    var body: some View {
        NavigationStack{
            VStack{
                Text("What's your age")
                Picker("", selection: $selectedAge){
                    ForEach(0..<100, id: \.self) {
                        age in
                        Text("\(age)").tag(age)
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


