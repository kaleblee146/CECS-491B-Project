//
//  Survey_3.swift
//  MoveMentorDraft
//
//  Created by Kaleb Lee on 3/11/25.
//
import SwiftUI

struct SurveyView3: View {
    var body: some View{
        NavigationStack{
            VStack{
                Text("Units of Measurement")
            }
            .frame(width: 402, height: 869)
            .background(Color.navy)
        }
    }
}

struct SurveyView3_Previews: PreviewProvider {
    static var previews: some View {
        SurveyView3()
    }
}
