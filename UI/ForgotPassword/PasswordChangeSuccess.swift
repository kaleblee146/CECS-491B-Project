//
//  PasswordChangeSuccess.swift
//  moveMentorPhoneTest
//
//  Created by Kaleb Lee on 4/6/25.
//



import SwiftUI

struct PasswordChangeSuccess: View {
    
    
    var body: some View{
        NavigationStack{
            VStack{
                Text("Password Changed Successfully!")
                    .font(Font.custom("Roboto_condensed-black", size: 18))
                    .foregroundColor(Color.white)
                 
                Text("To access the app again,")
                    .font(Font.custom("Roboto_condensed-black", size: 18))
                    .foregroundColor(Color.white)
                    

                
                Text("please restart the app and log in.")
                    .font(Font.custom("Roboto_condensed-black", size: 18))
                    .foregroundColor(Color.white)

                    
    
                    
            }
            .frame(width: 402, height: 869)
            .background(Color.navy)
            
                }
            }
        }
    


struct PasswordChangeSuccessPreviews: PreviewProvider {
    static var previews: some View {
        PasswordChangeSuccess()
    }
}
