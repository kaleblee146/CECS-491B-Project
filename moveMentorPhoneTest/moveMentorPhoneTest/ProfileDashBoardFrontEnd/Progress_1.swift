import SwiftUI

struct Progress_1_View: View {
    @EnvironmentObject var session: UserSession
    
    @State private var goToStats = false
    @State private var goToCalendar = false
    @State private var selectedButton: Int? = nil
    
    @Binding var selectedTab: BottomTab 
    
    var body: some View {
        NavigationStack {
            VStack {
                // User Circle + Info
                Circle()
                    .frame(width: 138, height: 138)
                Text("\(session.firstName) \(session.lastName)")
                Text("Member since \(String(session.joinedYear ?? 2025))")
                
                // User Stats Box
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.magenta)
                    .frame(width: 350, height: 80)
                    .overlay(
                        HStack {
                            VStack {
                                Text("\(session.height ?? 0.0, specifier: "%.1f")")
                                Text("Height")
                            }
                            .padding(20)
                            
                            VStack {
                                Text("\(session.age ?? 0)")
                                Text("Years old")
                            }
                            .padding(20)
                            
                            VStack {
                                Text("\(Int(session.weight ?? 0)) lbs")
                                Text("Weight")
                            }
                            .padding(20)
                        }
                    )
                    .padding(.bottom, 15)
                
                // Buttons
                HStack {
                    Button("Analytics") {
                        // Placeholder for future feature
                    }
                    .frame(width: 106, height: 45)
                    .background(Color.textBoxNavy)
                    .cornerRadius(15)
                    
                    Button("Calendar") {
                        goToCalendar = true
                    }
                    .frame(width: 106, height: 45)
                    .background(Color.textBoxNavy)
                    .cornerRadius(15)
                    
                    Button("Stats") {
                        goToStats = true
                    }
                    .frame(width: 106, height: 45)
                    .background(Color.textBoxNavy)
                    .cornerRadius(15)
                }

                // ScrollView: Summary Cards
                ScrollView {
                    VStack(spacing: 20) {
                        ProgressCard(image: "progress_best_workout", title: "Best Workout", subtitle: "27 Workouts Completed", date: "10/08/2020 17:24")
                        ProgressCard(image: "progress_workout_week", title: "Workout of the week", subtitle: "727 Workouts Completed", date: "7/08/2020 12:11")
                        ProgressCard(image: "progress_exercise_complete", title: "188 Workouts Completed", subtitle: "", date: "1/06/2020 18:23")
                    }
                    .padding(.top, 20)
                }
                .frame(height: 300)
                
                // Tab Navigation View Switch
                

                // Bottom Nav Bar
               
            }
            .frame(width: 402, height: 869)
            .ignoresSafeArea(edges: .bottom)
            .background(Color.navy.ignoresSafeArea())
            .onAppear {
                print("👀 Progress_1_View sees: \(session.firstName) \(session.lastName)")
            }
            
            
            
            
        }
        .fullScreenCover(isPresented: $goToCalendar) {
            Progress_2_View(selectedTab: $selectedTab)
        }
        

        .fullScreenCover(isPresented: $goToStats) {
            Progress_3_View(selectedTab: $selectedTab)
        }
    }
    
}

struct ProgressCard: View {
    var image: String
    var title: String
    var subtitle: String
    var date: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(Color.textBoxNavy)
            .frame(width: 348, height: 128)
            .overlay(
                HStack {
                    Image(image)
                        .padding()
                    VStack(alignment: .leading) {
                        Text(title).bold()
                        if !subtitle.isEmpty {
                            Text(subtitle)
                        }
                        Text(date).font(.caption)
                    }
                }
            )
    }
}
