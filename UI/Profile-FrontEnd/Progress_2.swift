//
//  Progress_2.swift
//  MoveMentorDraft
//
//  Created by Kaleb Lee on 3/16/25.
//

import SwiftUI

struct Progress_2_View: View {
@EnvironmentObject var session: UserSession
@State private var goToAnalytics = false
@State private var goToStats = false

    
    var body: some View{
        NavigationStack{
            VStack{
                Circle()
                    .frame(width: 138, height: 138)
                    .padding(.top, 80)
                Text("\(session.firstName) \(session.lastName)")
                Text("Member since \(String(session.joinedYear ?? 2025))")
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.magenta)
                    .frame(width: 350, height: 80)
                    .overlay(
                        HStack{
                            VStack{
                                Text("\(session.height ?? 0.0, specifier: "%.1f")")
                                Text("Height")
                            }
                            .padding(20)
                            
                            VStack{
                                Text("\(session.age ?? 0)")
                                Text("Years old")
                            }
                            .padding(20)
                            
                            VStack{
                                Text("\(Int(session.weight ?? 0)) lbs")
                                Text("Weight")
                            }
                            .padding(20)
                            
                        }
                    )
                    .padding(.bottom, 15)
                
                
                HStack{
                    Button("Analytics"){
                        goToAnalytics = true
                    }
                    .frame(width: 106, height: 45)
                    .background(Color.textBoxNavy)
                    .cornerRadius(15)
                    .buttonStyle(BorderlessButtonStyle())
                    
                    Button("Calendar"){
                        
                    }
                    .frame(width: 106, height: 45)
                    .background(Color.textBoxNavy)
                    .cornerRadius(15)
                    .buttonStyle(BorderlessButtonStyle())
                    
                    Button("Stats"){
                        goToStats = true
                    }
                    .frame(width: 106, height: 45)
                    .background(Color.textBoxNavy)
                    .cornerRadius(15)
                    .buttonStyle(BorderlessButtonStyle())
                    
                }
                CalendarView()
                
                ScrollView{
                   
                        HStack(alignment:.center){
                            Spacer()
                            Button("Planned"){
                                
                            }
                            .frame(width: 75, height: 35)
                            .buttonStyle(BorderlessButtonStyle())
                            .background(Color.textBoxNavy)
                            .cornerRadius(10)
                            
                            Image("Planned")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                        
                        HStack(alignment:.center){
                            Spacer()
                            Button("Completed"){
                                
                            }
                            .frame(width: 75, height: 35)
                            .buttonStyle(BorderlessButtonStyle())
                            .background(Color.textBoxNavy)
                            .cornerRadius(10)
                            
                            Image("Completed")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                    
                }
               
                NavBarView()
                
            }
            .frame(width: 402, height: 869)
            .background(Color.navy)
            .navigationDestination(isPresented: $goToAnalytics){
                Progress_1_View()
            }
            .navigationDestination(isPresented: $goToStats){
                Progress_3_View()
            }
        }
    }
}

struct Progress_2_View_Preview : PreviewProvider {
    static var previews: some View {
        Progress_2_View()
    }
}
