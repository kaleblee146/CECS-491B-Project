//
//  Survey_7.swift
//  MoveMentorDraft
//
//  Created by Kaleb Lee on 3/12/25.
//

import SwiftUI
import AVFoundation
import UIKit

struct SurveyView7: View {
    @State private var goBack = false
    @State private var continueButton = false
    
    var body: some View{
        NavigationStack{
            VStack{
                Text("Good job on completing your workout profile")
                    .font(Font.custom("Roboto_condensed-black", size: 18))
                    .padding(.bottom, 50)
                
                Text("Onto Step 2:")
                    .font(Font.custom("Roboto_condensed-black", size: 18))

                Text("Camera Callibration")
                    .font(Font.custom("Roboto_condensed-black", size: 18))
                    .padding(.bottom, 100)
                
                Rectangle()
                    .fill(Color.textBoxNavy)
                    .frame(width: 360, height: 66)
                    .overlay(
                        
                    Text("MoveMentor requires access to a camera to track your movements while you workout")
                        .font(Font.custom("Roboto_condensed-black", size: 15))

                    )
                    
                HStack{
                    Button("BACK"){
                        goBack = true
                    }
                    .font(Font.custom("Roboto_Condensed-Black", size: 18))
                    .frame(width: 164, height: 60)
                    .background(Color.blueMagenta)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .buttonStyle(BorderlessButtonStyle())
                    .padding()
                    

                    
                    Button("CONTINUE"){
                        checkCameraAccess()
                        continueButton = true
                    }
                    .font(Font.custom("Roboto_Condensed-Black", size: 18))
                    .frame(width: 164, height: 60)
                    .background(Color.magenta)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .buttonStyle(BorderlessButtonStyle())
                    .padding()
                }
                .padding(.top, 250)
                    
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.navy)
            .navigationDestination(isPresented: $goBack){
                SurveyView6()
            }
            .navigationDestination(isPresented: $continueButton){
                CallibrationView()
            }
        }
    }
}

func checkCameraAccess(){
    switch AVCaptureDevice.authorizationStatus(for: .video){
    case .authorized:
        print("Camera access already granted.")
    case .notDetermined:
        AVCaptureDevice.requestAccess(for: .video){ granted in
            if granted{
                print("Camera access granted.")
            } else {
                print("Camera access denied.")
            }
        }
    case .denied, .restricted:
        print("Camera access previously denied or restricted.")
    @unknown default:
        print("Unknown camera authorization status.")
    }
}

struct SurveyView7_Previews: PreviewProvider {
    static var previews: some View {
        SurveyView7()
    }
}
