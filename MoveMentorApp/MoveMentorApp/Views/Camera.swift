//
//  Camera.swift
//  MoveMentorApp
//
//  Created by Sebs on 4/8/25./Users/sebs/Documents/GitHub/CECS-491B-Project/MoveMentorApp/MoveMentorApp.xcodeproj
//

import SwiftUI

struct CameraView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                CameraUIView()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        Spacer()
                        NavigationLink(destination: ConfigurationView()) {
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
        }
    }
}

// Wrapper for original ViewController
struct CameraUIView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ViewController {
        return ViewController()
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
}

// TEMPORARY settings view so the app builds
struct ConfigurationView: View {
    var body: some View {
        Text("Settings Coming Soon!")
            .foregroundColor(.white)
            .background(Color.black)
            .ignoresSafeArea()
    }
}


