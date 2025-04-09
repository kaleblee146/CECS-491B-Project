//
//  NavBar.swift
//  MoveMentorDraft
//
//  Created by Kaleb Lee on 3/16/25.
//

import SwiftUI

struct NavBarView: View {
    var body: some View{
        NavigationStack{
            HStack{
                Image("home")
                    .padding(20)
                Image("workout")
                    .padding(20)
                Image("profile")
                    .padding(20)
                Image("search")
                    .padding(20)
                Image("gear")
                    .padding(20)
            }
            .frame(width: 375, height: 70)
        }
    }
}

struct NavBar_Previews : PreviewProvider {
    static var previews: some View {
        NavBarView()
    }
}
