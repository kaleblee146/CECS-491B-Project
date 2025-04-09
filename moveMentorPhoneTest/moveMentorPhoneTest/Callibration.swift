//
//  Callibration.swift
//  MoveMentorDraft
//
//  Created by Kaleb Lee on 3/12/25.
//

import SwiftUI

struct CallibrationView: View {
    @EnvironmentObject var session: UserSession
    
    @State private var accountSuccess = false
 
    
    
    var body: some View {
        NavigationStack{
            VStack {
                Text("Callibration")
                    .font(Font.custom("Roboto_Condensed-Black", size: 18))

                Rectangle()
                    .fill(Color.textBoxNavy)
                    .frame(width: 385, height: 87)
                    .overlay(
                        Text("Move your camera back to get all of you in the frame.... [and other suggestions]")
                            .font(Font.custom("Roboto_Condensed-Black", size: 18))
                            .foregroundColor(.gray)

                    )
                HStack{
                    RoundedRectangle(cornerRadius: 25)
                        .frame(width: 258, height: 461)
                    
                    VStack{
                        Button(action: {}){
                            Text("X: Level")
                        }
                        .font(Font.custom("Roboto_Condensed-Black", size: 18))
                        .frame(width: 125, height: 49)
                        .background(Color.magenta)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .buttonStyle(BorderlessButtonStyle())
                        
                        
                        Button(action: {}){
                            Text("Y: Level")
                        }
                        .font(Font.custom("Roboto_Condensed-Black", size: 18))
                        .frame(width: 125, height: 49)
                        .background(Color.magenta)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Button(action: {}){
                            Text("Lighting")
                        }
                        .font(Font.custom("Roboto_Condensed-Black", size: 18))
                        .frame(width: 125, height: 49)
                        .background(Color.textBoxNavy)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Button(action: {}){
                            Text("Height")
                        }
                        .font(Font.custom("Roboto_Condensed-Black", size: 18))
                        .frame(width: 125, height: 49)
                        .background(Color.magenta)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Button(action: {}){
                            Text("F.O.V")
                        }
                        .font(Font.custom("Roboto_Condensed-Black", size: 18))
                        .frame(width: 125, height: 49)
                        .background(Color.textBoxNavy)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .buttonStyle(BorderlessButtonStyle())
                       
                        Button(action: {}){
                            Text("Setting 1")
                        }
                        .font(Font.custom("Roboto_Condensed-Black", size: 18))
                        .frame(width: 125, height: 49)
                        .background(Color.textBoxNavy)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Button(action: {}){
                            Text("Setting 2")
                        }
                        .font(Font.custom("Roboto_Condensed-Black", size: 18))
                            .frame(width: 125, height: 49)
                            .background(Color.magenta)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .buttonStyle(BorderlessButtonStyle())
                        
                        Button(action: {}){
                            Text("Setting 3")
                        }
                        .font(Font.custom("Roboto_Condensed-Black", size: 18))
                        .frame(width: 125, height: 49)
                        .background(Color.magenta)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .buttonStyle(BorderlessButtonStyle())
                        
                    }
                }
                
                }
            Button("CONFIRM"){
                accountSuccess = true
            }
            .font(Font.custom("Roboto_Condensed-Black", size: 18))
            .frame(width: 164, height: 60)
            .background(Color.magenta)
            .foregroundColor(.white)
            .cornerRadius(15)
            .buttonStyle(BorderlessButtonStyle())
            .padding()
        }
        .frame(width: 402, height: 869)
        .background(Color.navy)
        .navigationDestination(isPresented: $accountSuccess){
            RegistrationSuccess()
        }
        
    }
        
}



