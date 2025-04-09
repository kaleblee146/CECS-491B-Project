//
//  ForgotPass_3.swift
//  MoveMentorDraft
//
//  Created by Kaleb Lee on 3/18/25.
//

import SwiftUI

struct ForgotPass_3: View{
    @State private var newPass: String = ""
    @State private var confirmNew: String = ""
    
    @State private var goNext = false
    @State private var cancel = false
    
    @State private var passMatch = false
    @State private var passMessage = ""
    
   
    
    
    
    var body: some View{
        NavigationStack{
            VStack{
                Text("Reset your password")
                    .font(Font.custom("Roboto_Condensed-Black", size: 18))
                    .padding(.bottom, 50)
                
                TextField("New Password", text: $newPass)
                    .font(Font.custom("Roboto_Condensed-Black", size: 18))
                    .frame(width: 347, height: 55)
                    .padding()
                    .background(Color.textBoxNavy)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disableAutocorrection(true)
                    .padding(.horizontal, 25)
                
                TextField("Confirm New Password", text: $confirmNew)
                    .font(Font.custom("Roboto_Condensed-Black", size: 18))
                    .frame(width: 347, height: 55)
                    .padding()
                    .background(Color.textBoxNavy)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disableAutocorrection(true)
                    .padding(.horizontal, 25)
                
                if !passMessage.isEmpty{
                    Text(passMessage)
                        .foregroundColor(passMatch ? .green : .red)
                }
                
                Button("CONTINUE"){
                    checkPass()
                    if passMatch{
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
                Progress_1_View()
            }
            .navigationDestination(isPresented: $cancel){
                ForgotPass_2()
            }
            
        }
        
    }
    private func checkPass(){
        if newPass == confirmNew{
            passMatch = true
            
        } else {
            passMatch = false
            passMessage = "The passwords do not match."
        }
    }
}

struct ForgotPass3Preview: PreviewProvider{
    static var previews: some View{
        ForgotPass_3()
    }
}
