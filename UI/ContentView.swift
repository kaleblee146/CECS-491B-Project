//
//  ContentView.swift
//  MoveMentorDraft
//
//  Created by Kaleb Lee on 2/4/25.
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

struct ContentView: View {
    @State private var goToLogin = false
    
    var body: some View {
        NavigationStack{
            ZStack {
                Image("Welcome")
                    .resizable()
                    .scaledToFit()
                    .ignoresSafeArea()
                    
                
                VStack {
                    Image("moveMentor")
                    
                    Text("MoveMentor")
                        .font(Font.custom("Roboto_Condensed-Black", size: 40))
                        .padding(.bottom, 30)
                    
                    
                    Text("Sculp Your Body")
                        .font(Font.custom("Roboto_Condensed-Black", size: 27))
                        .padding(.bottom, 100)
                    
                    
                    Button("Login") {
                        goToLogin = true
                    }
                    
                    .font(Font.custom("Roboto_Condensed-Black", size: 18))
                    .frame(width: 350, height: 50)
                    .background(Color.magenta)
                    .foregroundColor(.white)
                    .cornerRadius(25)
                    .padding(.bottom, 50)
                    .buttonStyle(BorderlessButtonStyle())
                    
                    
                    
                    Text("Don't have an account? ")
                    + Text("Sign up")
                        .foregroundColor(Color.magenta)
                    
                }
                
            }
            .padding()
            .navigationDestination(isPresented: $goToLogin) {
                LoginView()
            }
            
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
