import SwiftUI

struct HomeNavBarView: View {
    @EnvironmentObject var session: UserSession

    @State private var goToWorkout = false
    @State private var goToProfile = false
    @State private var goToExplore = false
    @State private var goToSettings = false
    
    @State private var selectedTab: BottomTab = .home
    
    var body: some View {
        NavigationStack {
            HStack {
                NavigationLink(destination: CameraView(), isActive: $goToWorkout) { EmptyView() }.hidden()
                NavigationLink(destination: Progress_1_View().environmentObject(session), isActive: $goToProfile) { EmptyView() }.hidden()
                NavigationLink(destination: ExploreView(), isActive: $goToExplore) { EmptyView() }.hidden()
                NavigationLink(destination: SettingsView(), isActive: $goToSettings) { EmptyView() }.hidden()
                
                HStack {
                    Spacer()
                    BottomIcon(iconName: "house.fill", isSelected: selectedTab == .home) {
                        selectedTab = .home
                    }
                    Spacer()
                    BottomIcon(iconName: "dumbbell.fill", isSelected: selectedTab == .workout) {
                        selectedTab = .workout
                        goToWorkout = true
                    }
                    Spacer()
                    BottomIcon(iconName: "person.fill", isSelected: selectedTab == .profile) {
                        selectedTab = .profile
                        goToProfile = true
                    }
                    Spacer()
                    BottomIcon(iconName: "magnifyingglass", isSelected: selectedTab == .explore) {
                        selectedTab = .explore
                        goToExplore = true
                    }
                    Spacer()
                    BottomIcon(iconName: "gearshape.fill", isSelected: selectedTab == .settings) {
                        selectedTab = .settings
                        goToSettings = true
                    }
                    Spacer()
                }
            }
        }
    }
}



struct WorkoutNavBarView: View {
    @EnvironmentObject var session: UserSession

    @State private var goToHome = false
    @State private var goToWorkout = false
    @State private var goToProfile = false
    @State private var goToExplore = false
    @State private var goToSettings = false
    
    @State private var selectedTab: BottomTab = .workout
    
    var body: some View {
        NavigationStack {
            HStack {
                NavigationLink(destination: HomeScreen().environmentObject(session), isActive: $goToHome) { EmptyView() }.hidden()
                NavigationLink(destination: Progress_1_View().environmentObject(session), isActive: $goToProfile) { EmptyView() }.hidden()
                NavigationLink(destination: ExploreView(), isActive: $goToExplore) { EmptyView() }.hidden()
                NavigationLink(destination: SettingsView(), isActive: $goToSettings) { EmptyView() }.hidden()
                
                HStack {
                    Spacer()
                    BottomIcon(iconName: "house.fill", isSelected: selectedTab == .home) {
                        selectedTab = .home
                        goToHome = true
                    }
                    Spacer()
                    BottomIcon(iconName: "dumbbell.fill", isSelected: selectedTab == .workout) {
                        selectedTab = .workout
                    }
                    Spacer()
                    BottomIcon(iconName: "person.fill", isSelected: selectedTab == .profile) {
                        selectedTab = .profile
                        goToProfile = true
                    }
                    Spacer()
                    BottomIcon(iconName: "magnifyingglass", isSelected: selectedTab == .explore) {
                        selectedTab = .explore
                        goToExplore = true
                    }
                    Spacer()
                    BottomIcon(iconName: "gearshape.fill", isSelected: selectedTab == .settings) {
                        selectedTab = .settings
                        goToSettings = true
                    }
                    Spacer()
                }
            }
        }
    }
}

struct ProfileNavBarView: View {
    @EnvironmentObject var session: UserSession

    @State private var goToWorkout = false
    @State private var goToHome = false
    @State private var goToExplore = false
    @State private var goToSettings = false
    
    @State private var selectedTab: BottomTab = .profile
    
    var body: some View {
        NavigationStack {
            HStack {
                NavigationLink(destination: CameraView(), isActive: $goToWorkout) { EmptyView() }.hidden()
                NavigationLink(destination: HomeScreen().environmentObject(session), isActive: $goToHome) { EmptyView() }.hidden()
                NavigationLink(destination: ExploreView(), isActive: $goToExplore) { EmptyView() }.hidden()
                NavigationLink(destination: SettingsView(), isActive: $goToSettings) { EmptyView() }.hidden()
                
                HStack {
                    Spacer()
                    BottomIcon(iconName: "house.fill", isSelected: selectedTab == .home) {
                        selectedTab = .home
                        goToHome = true
                    }
                    Spacer()
                    BottomIcon(iconName: "dumbbell.fill", isSelected: selectedTab == .workout) {
                        selectedTab = .workout
                        goToWorkout = true
                    }
                    Spacer()
                    BottomIcon(iconName: "person.fill", isSelected: selectedTab == .profile) {
                        selectedTab = .profile
                    }
                    Spacer()
                    BottomIcon(iconName: "magnifyingglass", isSelected: selectedTab == .explore) {
                        selectedTab = .explore
                        goToExplore = true
                    }
                    Spacer()
                    BottomIcon(iconName: "gearshape.fill", isSelected: selectedTab == .settings) {
                        selectedTab = .settings
                        goToSettings = true
                    }
                    Spacer()
                }
            }
        }
    }
}

struct ExploreNavBarView: View {
    @EnvironmentObject var session: UserSession

    @State private var goToWorkout = false
    @State private var goToProfile = false
    @State private var goToSettings = false
    @State private var goToHome = false
    
    @State private var selectedTab: BottomTab = .explore
    
    var body: some View {
        NavigationStack {
            HStack {
                NavigationLink(destination: CameraView(), isActive: $goToWorkout) { EmptyView() }.hidden()
                NavigationLink(destination: Progress_1_View().environmentObject(session), isActive: $goToProfile) { EmptyView() }.hidden()
                NavigationLink(destination: HomeScreen().environmentObject(session), isActive: $goToHome) { EmptyView() }.hidden()
                NavigationLink(destination: SettingsView(), isActive: $goToSettings) { EmptyView() }.hidden()
                
                HStack {
                    Spacer()
                    BottomIcon(iconName: "house.fill", isSelected: selectedTab == .home) {
                        selectedTab = .home
                        goToHome = true
                    }
                    Spacer()
                    BottomIcon(iconName: "dumbbell.fill", isSelected: selectedTab == .workout) {
                        selectedTab = .workout
                        goToWorkout = true
                    }
                    Spacer()
                    BottomIcon(iconName: "person.fill", isSelected: selectedTab == .profile) {
                        selectedTab = .profile
                        goToProfile = true
                    }
                    Spacer()
                    BottomIcon(iconName: "magnifyingglass", isSelected: selectedTab == .explore) {
                        selectedTab = .explore
                    }
                    Spacer()
                    BottomIcon(iconName: "gearshape.fill", isSelected: selectedTab == .settings) {
                        selectedTab = .settings
                        goToSettings = true
                    }
                    Spacer()
                }
            }
        }
    }
}

struct SettingsNavBarView: View {
    @EnvironmentObject var session: UserSession

    @State private var goToWorkout = false
    @State private var goToProfile = false
    @State private var goToExplore = false
    @State private var goToHome = false
    
    @State private var selectedTab: BottomTab = .settings
    
    var body: some View {
        NavigationStack {
            HStack {
                NavigationLink(destination: CameraView(), isActive: $goToWorkout) { EmptyView() }.hidden()
                NavigationLink(destination: Progress_1_View().environmentObject(session), isActive: $goToProfile) { EmptyView() }.hidden()
                NavigationLink(destination: ExploreView(), isActive: $goToExplore) { EmptyView() }.hidden()
                NavigationLink(destination: HomeScreen().environmentObject(session), isActive: $goToHome) { EmptyView() }.hidden()
                
                HStack {
                    Spacer()
                    BottomIcon(iconName: "house.fill", isSelected: selectedTab == .home) {
                        selectedTab = .home
                        goToHome = true
                    }
                    Spacer()
                    BottomIcon(iconName: "dumbbell.fill", isSelected: selectedTab == .workout) {
                        selectedTab = .workout
                        goToWorkout = true
                    }
                    Spacer()
                    BottomIcon(iconName: "person.fill", isSelected: selectedTab == .profile) {
                        selectedTab = .profile
                        goToProfile = true
                    }
                    Spacer()
                    BottomIcon(iconName: "magnifyingglass", isSelected: selectedTab == .explore) {
                        selectedTab = .explore
                        goToExplore = true
                    }
                    Spacer()
                    BottomIcon(iconName: "gearshape.fill", isSelected: selectedTab == .settings) {
                        selectedTab = .settings
                    }
                    Spacer()
                }
            }
        }
    }
}
