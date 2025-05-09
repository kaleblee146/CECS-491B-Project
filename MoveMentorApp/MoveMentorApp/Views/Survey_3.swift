//
//  Survey_3.swift
//  MoveMentorDraft
//
//  Created by Kaleb Lee on 3/11/25.
//
import SwiftUI

struct SurveyView3: View {
    @State private var goBack = false
    @State private var continueButton = false
    
    @State private var selectedUnit: unit = .Select
    
    enum unit: String, CaseIterable, Identifiable {
        case Select, Imperial, Metric
        var id : Self {self}
    }
   
    var body: some View{
        NavigationStack{
            VStack{
                Text("Units of")
                    .font(Font.custom("Roboto_Condensed-Black", size: 18))
                    
                Text("Measurement")
                    .font(Font.custom("Roboto_Condensed-Black", size: 18))
                    .padding(.bottom, 50)
                
                Text("Select units")
                    .font(Font.custom("Roboto_Condensed-Black", size: 18))
                    .padding(.top, 20)
                
                Picker("", selection: $selectedUnit){
                    ForEach(unit.allCases) {
                        value in Text(value.rawValue).tag(value)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(width: 133, height: 42)
                
                
                
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
                SurveyView2()
            }
            .navigationDestination(isPresented: $continueButton){
                SurveyView4()
            }
        }
    }
}

struct SurveyView3_Previews: PreviewProvider {
    static var previews: some View {
        SurveyView3()
    }
}
