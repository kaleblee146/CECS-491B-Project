//
//  ForgotPass_2.swift
//  MoveMentorDraft
//
//  Created by Kaleb Lee on 3/18/25.
//

import SwiftUI

struct ForgotPass_2: View{
    @State private var goNext = false
    @State private var cancel = false
    
    @State private var verifCode: String = ""
    @State private var verifMatch = false
    @State private var verifMessage = ""
    
    private let verificationCode = "12345"
    
    
    
    var body: some View{
        NavigationStack{
            VStack{
                
                Text("Reset your password")
                    .font(Font.custom("Roboto_Condensed-Black", size: 18))
                    .padding(.bottom, 50)
                
                Text("Enter the 6-digit verification code sent to ******@gmail.com")
                    .font(Font.custom("Roboto_Condensed-Black", size: 18))
                    .padding(.bottom, 120)
                
                TextField("Verification Code", text: $verifCode)
                    .font(Font.custom("Roboto_Condensed-Black", size: 18))
                    .frame(width: 347, height: 55)
                    .padding()
                    .background(Color.textBoxNavy)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disableAutocorrection(true)
                    .padding(.horizontal, 25)
                
                if !verifMessage.isEmpty{
                    Text(verifMessage)
                        .foregroundColor(verifMatch ? .green : .red)
                }

                
                Button("CONTINUE"){
                    checkVerif()
                    if verifMatch{
                        goNext = true
                    }
                }
                .font(Font.custom("Roboto_Condensed-Black", size: 18))
                .frame(width: 347, height: 55)
                .background(Color.magenta)
                .foregroundColor(.white)
                .cornerRadius(10)
                .buttonStyle(BorderlessButtonStyle())
                .padding(.top, 50)
                .padding()
                
                Button("CANCEL"){
                    cancel = true
                }
                .font(Font.custom("Roboto_Condensed-Black", size: 18))
                .frame(width: 347, height: 55)
                .background(Color.blueMagenta)
                .foregroundColor(.white)
                .cornerRadius(10)
                .buttonStyle(BorderlessButtonStyle())
                
            }
            .frame(width: 402, height: 869)
            .background(Color.navy)
            .navigationDestination(isPresented: $goNext){
                ForgotPass_3()
            }
            .navigationDestination(isPresented: $cancel){
                ForgotPass_1()
            }
               
                
                
                
            }
            
        }
    private func checkVerif(){
        if verifCode == verificationCode{
            verifMatch = true
            
        } else {
            verifMatch = false
            verifMessage = "The verification code entered is incorrect."
        }
    }
        
    }


struct ForgotPass2Preview: PreviewProvider{
    static var previews: some View{
        ForgotPass_2()
    }
}
