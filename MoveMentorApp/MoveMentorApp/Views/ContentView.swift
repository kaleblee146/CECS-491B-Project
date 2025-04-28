import SwiftUI

struct ContentView: View {
    @State private var goToLogin = false
    @State private var goToSignUp = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Background Welcome Image
                Image("Welcome")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    Image("MoveMentor")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150) // optional sizing
                    
                    Text("MoveMentor")
                        .font(Font.custom("Roboto_Condensed-Black", size: 40))
                        .padding(.top, 30)
                    
                    Text("Sculpt Your Body") 
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
                    
                    HStack {
                        Text("Don't have an account?")
                        Button("Sign up") {
                            goToSignUp = true
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .foregroundColor(Color.magenta)
                    }
                    .padding(.top, 50)
                }
                .padding()
            }
            .navigationDestination(isPresented: $goToLogin) {
                LoginView()
            }
            .navigationDestination(isPresented: $goToSignUp) {
                CreateAccountView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
