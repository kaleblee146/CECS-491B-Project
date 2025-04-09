//
//  LoginFailView.swift
//  MoveMentorDraft
//
//  Created by Kaleb Lee on 3/10/25.
//

import SwiftUI
import GoogleSignIn
import Firebase

struct LoginView: View {
    @EnvironmentObject var session: UserSession
    @StateObject private var authVM: LoginAuthViewModel
    
    @State private var selectedTab: BottomTab = .home

    
    @State private var signUp = false
    @State private var navigateToNext = false
    @State private var forgotPass = false
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var loginMessage: String = ""
    
    init(session: UserSession) {
        _authVM = StateObject(wrappedValue: LoginAuthViewModel(session: session))
    }
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("Login")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 250)
                    .ignoresSafeArea(edges: .top)
                
                Text("Welcome Back")
                    .font(.system(size: 38))
                    .padding(.bottom, 5)
                
                Text("Login into your account")
                    .font(.system(size: 18))
                    .padding(.bottom, 10)
                
                TextField("Username", text: $username, )
                    .padding()
                    .background(Color.textBoxNavy)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .colorScheme(.dark)
                    .padding(.horizontal, 25)
                    .padding(.bottom, 10)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.textBoxNavy)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .colorScheme(.dark)
                    .padding(.horizontal, 25)
                    .padding(.bottom, 10)
                
                Button(action: checkLogin) {
                    Text("Continue")
                }
                .font(Font.custom("Roboto_Condensed-Black", size: 18))
                .frame(width: 350, height: 55)
                .background(Color.magenta)
                .foregroundColor(.white)
                .cornerRadius(10)
                .buttonStyle(BorderlessButtonStyle())
                .padding(.bottom, 10)
                .navigationDestination(isPresented: $navigateToNext) {
                    MainTabController()
                            .environmentObject(session)
                }
                
                
                if !loginMessage.isEmpty {
                    Text(loginMessage)
                        .foregroundColor(loginMessage == "Login Successful!" ? .green : .red)
                        .padding(.bottom, 10)
                }
                
                
                Button(action: {
                    signInWithGoogle()
                }) {
                    HStack {
                        Image("google")
                        Text("Sign in with Google")
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, 16)
                }
                .font(Font.custom("Roboto_Condensed-Black", size: 18))
                .frame(width: 380, height: 42)
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(10)
                .buttonStyle(BorderlessButtonStyle())
                .padding(.top, 10)
                
                
                Button(action: {}) {
                    HStack {
                        Image("apple")
                        Text("Sign in with Apple")
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, 16)
                }
                .font(Font.custom("Roboto_Condensed-Black", size: 18))
                .frame(width: 380, height: 42)
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(10)
                .buttonStyle(BorderlessButtonStyle())
                .padding(.top, 10)
                
                
                Button(action: {
                    forgotPass = true
                }) {
                    Text("Forgot Password?")
                        .foregroundColor(Color.magenta)
                        .underline()
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(.top, 15)
                .navigationDestination(isPresented: $forgotPass) {
                    ForgotPass_1()
                }
                
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.white)
                    Button("Sign up") {
                        signUp = true
                    }
                    .foregroundColor(Color.magenta)
                    .buttonStyle(BorderlessButtonStyle())
                }
                .padding(.top, 10)
                .navigationDestination(isPresented: $signUp) {
                    CreateAccountView()
                }
                
                Spacer()
            }
            .onChange(of: session.isAuthenticated) { oldValue, newValue in if newValue {
                loginMessage = "Login Successful!"
                navigateToNext = true
            }
            }
            .frame(width: 402, height: 869)
            .background(Color.navy)
        }
        
        
    }
    
    
    private func checkLogin() {
        authVM.login(username: username, password: password)
    }
    
    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            print("❌ Firebase client ID not found")
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            print("❌ Could not find root view controller")
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            if let error = error {
                print("❌ Google Sign-In failed: \(error.localizedDescription)")
                loginMessage = "Google Sign-In failed"
                return
            }

            // 🔓 Unwrap result
            guard let result = result else {
                print("❌ No sign-in result returned")
                loginMessage = "Google Sign-In failed"
                return
            }

            // 🧠 Now access the user
            guard let idToken = result.user.idToken?.tokenString else {
                print("❌ No ID Token retrieved")
                loginMessage = "Google Sign-In failed"
                return
            }

            print("✅ Google ID token: \(idToken)")
            loginMessage = "Signing in..."
            authVM.socialLogin(idToken: idToken, provider: "google")
        }

        
        
    }
}

