//
//  Camera.swift
//  MoveMentorApp
//
//  Created by Sebs on 4/8/25./Users/sebs/Documents/GitHub/CECS-491B-Project/MoveMentorApp/MoveMentorApp.xcodeproj
//

import SwiftUI

struct CameraView: View {
    var body: some View {
        ZStack {
            CameraUIView()
                .edgesIgnoringSafeArea(.all)
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
}

// Wrap the UIKit camera view
struct CameraUIView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ViewController {
        return ViewController()
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
}

// You can also delete or keep this if you want to reuse ConfigurationView later
struct ConfigurationView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Text("Settings Coming Soon!")
                .foregroundColor(.white)
                .font(.title)
        }
    }
}
