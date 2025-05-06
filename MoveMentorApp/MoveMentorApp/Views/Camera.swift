//
//  Camera.swift
//  MoveMentorApp
//
//  Created by Sebs on 4/8/25./Users/sebs/Documents/GitHub/CECS-491B-Project/MoveMentorApp/MoveMentorApp.xcodeproj
//

import SwiftUI

struct CameraView: View {
    @State private var goToSettings = false

    var body: some View {
        ZStack {
            CameraUIView()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        goToSettings = true
                    }) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                Spacer()
            }
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
        .fullScreenCover(isPresented: $goToSettings) {
            ConfigurationView()
        }
    }
}

// Wrap the UIKit camera view
struct CameraUIView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ViewController {
        return ViewController()
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
}

// Simple placeholder settings screen
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
