//
//  moveMentorPhoneTestApp.swift
//  moveMentorPhoneTest
//
//  Created by Kaleb Lee on 3/19/25.
//

import SwiftUI
import Firebase

@main
struct moveMentorPhoneTestApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var session = UserSession()
    
    var body: some Scene {
        
        WindowGroup {
            ContentView(registrationData: RegistrationData())
                .environmentObject(session)
        }
    }
}
