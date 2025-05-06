//
//  Camera.swift
//  MoveMentorApp
//
//  Created by Sebs on 4/8/25./Users/sebs/Documents/GitHub/CECS-491B-Project/MoveMentorApp/MoveMentorApp.xcodeproj
//

import SwiftUI

struct CameraView: UIViewControllerRepresentable {
    @EnvironmentObject var session: UserSession

    func makeUIViewController(context: Context) -> ViewController {
        return ViewController()
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
}


