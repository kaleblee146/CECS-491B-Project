//
//  MoveMentorAppApp.swift
//  MoveMentorApp
//
//  Created by Chase Sansom on 4/6/25.
//

import SwiftUI

@main
struct MoveMentorApp: App {
    @AppStorage("darkMode") private var darkMode = true

    @StateObject private var registrationData = RegistrationData()
    @StateObject private var session = UserSession()

    var body: some Scene {
        WindowGroup {
            Group {
                if session.isLoggedIn {
                    ContentView()
                } else {
                    LoginView()
                }
            }
            .preferredColorScheme(darkMode ? .dark : .light)
            .environmentObject(registrationData)
            .environmentObject(session)
        }
    }
}
