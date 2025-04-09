//
//  MainTabControlloer.swift
//  moveMentorPhoneTest
//
//  Created by Kaleb Lee on 4/9/25.
//

import SwiftUI

struct MainTabController: View {
    @State private var selectedTab: BottomTab = .home
    @EnvironmentObject var session: UserSession

    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case .home:
                    HomeScreen(selectedTab: $selectedTab)
                case .profile:
                    Progress_1_View(selectedTab: $selectedTab)
                case .workout:
                    WorkoutView()
                case .explore:
                    ExploreView()
                case .settings:
                    SettingsView()
                }
            }
            .environmentObject(session)

            VStack {
                Spacer()
                BottomNavigationBar(selectedTab: $selectedTab)
                    .padding(.bottom, 10)
            }
        }
        .background(Color.navy.ignoresSafeArea())
    }
}

struct MainTabController_Previews: PreviewProvider {
    static var previews: some View {
        MainTabController()
            .environmentObject(UserSession())
    }
}
