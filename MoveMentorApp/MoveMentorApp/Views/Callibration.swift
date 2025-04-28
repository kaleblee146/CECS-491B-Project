//
//  Callibration.swift
//  MoveMentorDraft
//
//  Created by Kaleb Lee on 3/12/25.
//

import SwiftUI
import AVFoundation
import UIKit

struct CameraViewSetPreview: UIViewRepresentable {
    private let session = AVCaptureSession()
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: device) else {
            return view
        }
        
        session.addInput(input)
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = UIScreen.main.bounds
        view.layer.addSublayer(previewLayer)
        
        session.startRunning()
        
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct CallibrationView: View {
    @State private var goToHome = false
    
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
                    CameraView()
                        .frame(width: 258, height: 461)
                        .cornerRadius(25)
                        .clipped()
                    
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
                goToHome = true
            }
            .font(Font.custom("Roboto_Condensed-Black", size: 18))
            .frame(width: 164, height: 60)
            .background(Color.magenta)
            .foregroundColor(.white)
            .cornerRadius(15)
            .buttonStyle(BorderlessButtonStyle())
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.navy)
        .navigationDestination(isPresented: $goToHome){
            HomeScreen()
        }
        
    }
        
}



struct CallibrationView_Previews : PreviewProvider {
    static var previews: some View {
        CallibrationView()
    }
}
