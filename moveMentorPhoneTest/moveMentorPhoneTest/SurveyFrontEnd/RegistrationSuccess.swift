//
//  RegistrationSuccess.swift
//  moveMentorPhoneTest
//
//  Created by Kaleb Lee on 4/4/25.
//


import SwiftUI

struct RegistrationSuccess: View {
    
    
    var body: some View{
        NavigationStack{
            VStack{
                Text("Good job on completing your workout")
                    .font(Font.custom("Roboto_condensed-black", size: 18))
                    .foregroundColor(Color.white)
                 
                Text("profile and callibration settings!")
                    .font(Font.custom("Roboto_condensed-black", size: 18))
                    .foregroundColor(Color.white)
                    .padding(.bottom, 50)

                
                Text("Please restart the app and log in.")
                    .font(Font.custom("Roboto_condensed-black", size: 18))
                    .foregroundColor(Color.white)

                    
    
                    
            }
            .frame(width: 402, height: 869)
            .background(Color.navy)
            
                }
            }
        }
    


struct RegistrationSuccessPreviews: PreviewProvider {
    static var previews: some View {
        RegistrationSuccess()
    }
}
