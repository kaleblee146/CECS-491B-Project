import SwiftUI

struct Progress_2_View: View {
    @EnvironmentObject var session: UserSession
    
    @Binding var selectedTab: BottomTab
    
    @State private var goToAnalytics = false
    @State private var goToStats = false
    
    var body: some View {
        NavigationStack {
            VStack {
                // Profile Circle
                Circle()
                    .frame(width: 138, height: 138)
                    .padding(.top, 80)
                
                // Name & Join Date
                Text("\(session.firstName) \(session.lastName)")
                Text("Member since \(String(session.joinedYear ?? 2025))")
                
                // Stats Summary Box
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.magenta)
                    .frame(width: 350, height: 80)
                    .overlay(
                        HStack {
                            VStack {
                                Text("\(session.height ?? 0.0, specifier: "%.1f")")
                                Text("Height")
                            }.padding(20)
                            
                            VStack {
                                Text("\(session.age ?? 0)")
                                Text("Years old")
                            }.padding(20)
                            
                            VStack {
                                Text("\(Int(session.weight ?? 0)) lbs")
                                Text("Weight")
                            }.padding(20)
                        }
                    )
                    .padding(.bottom, 15)
                
                // Top 3 Buttons
                HStack {
                    Button("Analytics") {
                        goToAnalytics = true
                    }
                    .frame(width: 106, height: 45)
                    .background(Color.textBoxNavy)
                    .cornerRadius(15)
                    
                    Button("Calendar") {
                        // Already on Calendar, do nothing
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
                
                // Calendar component
                CalendarView()
                
                // Planned / Completed
                ScrollView {
                    VStack(spacing: 20) {
                        HStack {
                            Spacer()
                            Button("Planned") { }
                                .frame(width: 75, height: 35)
                                .background(Color.textBoxNavy)
                                .cornerRadius(10)
                            
                            Image("Planned")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                        
                        HStack {
                            Spacer()
                            Button("Completed") { }
                                .frame(width: 75, height: 35)
                                .background(Color.textBoxNavy)
                                .cornerRadius(10)
                            
                            Image("Completed")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                    }
                }
                
                // Tab Navigation
                Group {
                    switch selectedTab {
                    case .home:
                        HomeContent()
                    case .workout:
                        WorkoutView()
                    case .profile:
                        Color.clear
                    case .explore:
                        ExploreView()
                    case .settings:
                        SettingsView()
                    }
                }
                
                BottomNavigationBar(selectedTab: $selectedTab)
                    .padding(.bottom, 10)
            }
            .frame(width: 402, height: 869)
            .background(Color.navy)
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $goToAnalytics) {
                Progress_1_View(selectedTab: $selectedTab)
            }
            .navigationDestination(isPresented: $goToStats) {
                Progress_3_View(selectedTab: $selectedTab)
            }
        }
    }
}
