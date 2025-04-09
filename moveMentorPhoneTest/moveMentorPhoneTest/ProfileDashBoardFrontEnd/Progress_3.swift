import SwiftUI

struct Progress_3_View: View {
    @EnvironmentObject var session: UserSession
    @State private var goToAnalytics = false
    @State private var goToCalendar = false

    @Binding var selectedTab: BottomTab
    
    var body: some View {
        NavigationStack {
            VStack {
                // Profile Image
                Circle()
                    .frame(width: 138, height: 138)
                    .padding(.bottom, 25)

                // User Info
                Text("\(session.firstName) \(session.lastName)")
                Text("Member since \(String(session.joinedYear ?? 2025))")
                
                // Stats Card
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

                // Navigation Buttons
                HStack {
                    Button("Analytics") {
                        goToAnalytics = true
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
                        // Current page — do nothing
                    }
                    .frame(width: 106, height: 45)
                    .background(Color.textBoxNavy)
                    .cornerRadius(15)
                }
                
                // Graph Section
                VStack {
                    MonthView()
                    LineGraphView()
                }
                
                // Bottom Tab Routing
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
            .navigationDestination(isPresented: $goToAnalytics) {
                Progress_1_View(selectedTab: $selectedTab)
            }
            .navigationDestination(isPresented: $goToCalendar) {
                Progress_2_View(selectedTab: $selectedTab)
            }
        }
    }
}
