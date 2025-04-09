//
//  Progress_1.swift
//  MoveMentorDraft
//
//  Created by Kaleb Lee on 3/16/25.
//
import SwiftUI

struct Progress_1_View: View {
    @EnvironmentObject var session: UserSession
    
    @State private var goToStats = false
    @State private var goToCalendar = false
    @State private var selectedButton: Int? = nil
    
    var body: some View{
        NavigationStack{
            VStack{
                Circle()
                    .frame(width: 138, height: 138)
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
                        
                    }
                    .frame(width: 106, height: 45)
                    .background(Color.textBoxNavy)
                    .cornerRadius(15)
                    .buttonStyle(BorderlessButtonStyle())
                    
                    Button("Calendar"){
                        goToCalendar = true
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
                ScrollView{
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.textBoxNavy)
                        .frame(width: 348, height: 128)
                        .padding(.top, 20)
                        .overlay(
                            HStack{
                                Image("progress_best_workout")
                                    .padding()
                                VStack{
                                    Text("Best Workout")
                                    Text("27 Workouts Completed")
                                    Text("10/08/2020 17:24")
                                }
                            }
                            )
                    
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.textBoxNavy)
                        .frame(width: 348, height: 128)
                        .padding(.top, 20)
                        .overlay(
                            HStack{
                                Image("progress_workout_week")
                                    .padding()
                                VStack{
                                    Text("Workout of the week")
                                    Text("727 Workouts Completed")
                                    Text("7/08/2020 12:11")
                                }
                            }
                            )
                    
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.textBoxNavy)
                        .frame(width: 348, height: 128)
                        .padding(.top, 20)
                        .overlay(
                            HStack{
                                Image("progress_exercise_complete")
                                    .padding()
                                VStack{
                                    Text("188 Workouts Completed")
                                    Text("1/06/2020 18:23")
                                }
                            }
                            )
                }
                .frame(height:300)
                
                NavBarView()
            }
            .frame(width: 402, height: 869)
            .background(Color.navy)
            .navigationDestination(isPresented: $goToCalendar){
                Progress_2_View()
            }
            .navigationDestination(isPresented: $goToStats){
                Progress_3_View()
            }
            
            .onAppear {
                print("👀 Progress_1_View sees: \(session.firstName) \(session.lastName)")
                
            }
        }
    }
}

struct Progress_1_Previews : PreviewProvider {
    static var previews: some View {
        Progress_1_View()
    }
}
