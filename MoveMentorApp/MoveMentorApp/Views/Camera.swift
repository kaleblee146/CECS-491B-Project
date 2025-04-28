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
            ZStack(alignment: .topTrailing) {
                CameraUIView()

                // Gear Icon Button
                NavigationLink(destination: ConfigurationView()) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .padding()
                }
            }
            .background(Color.black)
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct CameraView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ViewController {
        return ViewController()
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
}


