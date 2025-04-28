//
//  Colors.swift
//  MoveMentorDraft
//
//  Created by Kaleb Lee on 3/11/25.
//
import SwiftUI

extension Color {
    static let magenta = Color(red: 288/255, green: 68/255, blue: 124/255)
}

extension Color {
    static let navy = Color(red: 42/255, green: 46/255, blue: 67/255)
}

extension Color {
    static let textBoxNavy = Color(red: 53/255, green: 58/255, blue: 80/255)
}

extension Color {
    static let blueMagenta = Color(red: 102/255, green: 94/255, blue: 255/255)
}

extension Color {
    init(hex: String) {
        let hex = hex.replacingOccurrences(of: "#", with: "")
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let red = Double((int >> 16) & 0xFF) / 255.0
        let green = Double((int >> 8) & 0xFF) / 255.0
        let blue = Double(int & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}
