//
//  NavBar.swift
//  MoveMentorDraft
//
//  Created by Kaleb Lee on 3/16/25.
//

import SwiftUI

struct BottomNavigationBar: View {
    @Binding var selectedTab: BottomTab

    var body: some View {
        HStack {
            Spacer()
            BottomIcon(iconName: "house.fill", isSelected: selectedTab == .home) {
                selectedTab = .home
            }
            Spacer()
            BottomIcon(iconName: "dumbbell.fill", isSelected: selectedTab == .workout) {
                selectedTab = .workout
            }
            Spacer()
            BottomIcon(iconName: "person.fill", isSelected: selectedTab == .profile) {
                selectedTab = .profile
            }
            Spacer()
            BottomIcon(iconName: "magnifyingglass", isSelected: selectedTab == .explore) {
                selectedTab = .explore
            }
            Spacer()
            BottomIcon(iconName: "gearshape.fill", isSelected: selectedTab == .settings) {
                selectedTab = .settings
            }
            Spacer()
        }
        .padding()
        .background(Color(hex: "2A2E43").opacity(0.8))
        .clipShape(Capsule())
        .padding(.bottom, 1)
    }
}



