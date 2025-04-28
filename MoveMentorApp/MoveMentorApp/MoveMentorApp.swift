//
//  MoveMentorAppApp.swift
//  MoveMentorApp
//
//  Created by Chase Sansom on 4/6/25.
//

import SwiftUI

@main
struct MoveMentorApp: App {
    @StateObject private var registrationData = RegistrationData()
    @StateObject private var session = UserSession()
    var body: some Scene {
        WindowGroup {
            //HomeScreen()
            ContentView()
                .environmentObject(registrationData)
                .environmentObject(session)
        }
    }
}
