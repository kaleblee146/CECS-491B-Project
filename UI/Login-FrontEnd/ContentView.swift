    //
    //  ContentView.swift
    //  moveMentorPhoneTest
    //
    //  Created by Kaleb Lee on 3/19/25.
    //


    import SwiftUI


    struct ContentView: View {
        @EnvironmentObject var session: UserSession
        @ObservedObject var registrationData: RegistrationData
        /*
         Variables for Navigation
         */
        @State private var goToLogin = false
        @State private var goToSignUp = false
            
        var body: some View {
            NavigationStack{
                GeometryReader{ geometry in
                    ZStack {
                        Image("Welcome")
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                        
                        VStack {
                            Image("moveMentor")
                            
                            Text("MoveMentor")
                                .font(Font.custom("Roboto_Condensed-Black", size: 40))
                                .padding(.top, 30)
                            
                            Text("Sculp Your Body")
                                .font(Font.custom("Roboto_Condensed-Black", size: 27))
                                .padding(.top, 50)
                            
                            Button("Login") {
                                goToLogin = true
                            }
                            
                            .font(Font.custom("Roboto_Condensed-Black", size: 18))
                            .frame(width: 350, height: 50)
                            .background(Color.magenta)
                            .foregroundColor(.white)
                            .cornerRadius(25)
                            .padding(.top, 75)
                            .buttonStyle(BorderlessButtonStyle())
                            
                            
                            HStack{
                                Text("Don't have an account?")
                                Button("Sign up"){
                                    goToSignUp = true
                                }
                                .buttonStyle(BorderlessButtonStyle())
                                .foregroundColor(Color.magenta)
                            }
                            .padding(.top, 50)
                        }
                        .frame(width: geometry.size.width)
                        .padding()
                        
                    }
                    
                    .navigationDestination(isPresented: $goToLogin) {
                        LoginView(session: session)
                            
                    }
                    .navigationDestination(isPresented: $goToSignUp){
                        CreateAccountView()
                    }
                    
                    
                }
            }
        }
    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView(registrationData: RegistrationData())
                .environmentObject(UserSession())
        }
    }
