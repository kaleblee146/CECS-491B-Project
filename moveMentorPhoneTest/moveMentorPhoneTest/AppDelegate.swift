//
//  AppDelegate.swift
//  moveMentorPhoneTest
//
//  Created by Kaleb Lee on 4/8/25.
//

import UIKit
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        if let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
           let options = FirebaseOptions(contentsOfFile: filePath) {
            
            FirebaseApp.configure(options: options)
            print("✅ Firebase manually configured.")
            
            if let clientID = options.clientID {
                print("✅ Firebase Client ID loaded: \(clientID)")
            } else {
                print("❌ Client ID still missing in options.")
            }
        } else {
            print("❌ Could not find or load GoogleService-Info.plist")
        }

        return true  // ✅ Don't forget this!
    }
}
