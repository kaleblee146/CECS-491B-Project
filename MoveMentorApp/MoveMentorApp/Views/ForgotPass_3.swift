//
//  ForgotPass_3.swift
//  MoveMentorDraft
//
//  Created by Kaleb Lee on 3/18/25.
//

import SwiftUI

struct ForgotPass_3: View {
    let email: String
    let code: String

    @State private var newPass: String = ""
    @State private var confirmNew: String = ""

    @State private var goNext = false
    @State private var cancel = false

    @State private var passMatch = false
    @State private var passMessage = ""

    var body: some View {
        NavigationStack {
            VStack {
                Text("Reset your password")
                    .font(Font.custom("Roboto_Condensed-Black", size: 18))
                    .padding(.bottom, 50)

                SecureField("New Password", text: $newPass)
                    .font(Font.custom("Roboto_Condensed-Black", size: 18))
                    .frame(width: 347, height: 55)
                    .padding()
                    .background(Color.textBoxNavy)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disableAutocorrection(true)
                    .padding(.horizontal, 25)

                SecureField("Confirm New Password", text: $confirmNew)
                    .font(Font.custom("Roboto_Condensed-Black", size: 18))
                    .frame(width: 347, height: 55)
                    .padding()
                    .background(Color.textBoxNavy)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disableAutocorrection(true)
                    .padding(.horizontal, 25)

                if !passMessage.isEmpty {
                    Text(passMessage)
                        .foregroundColor(passMatch ? .green : .red)
                        .padding(.top)
                }

                Button("CONTINUE") {
                    Task {
                        await checkAndSubmit()
                    }
                }
                .font(Font.custom("Roboto_Condensed-Black", size: 18))
                .frame(width: 347, height: 55)
                .background(Color.magenta)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.top, 50)
                .padding()

                Button("CANCEL") {
                    cancel = true
                }
                .font(Font.custom("Roboto_Condensed-Black", size: 18))
                .frame(width: 347, height: 55)
                .background(Color.blueMagenta)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .frame(width: 402, height: 869)
            .background(Color.navy)
            .navigationDestination(isPresented: $goNext) {
                Progress_1_View()
            }
            .navigationDestination(isPresented: $cancel) {
                ForgotPass_2(email: email)  // Go back with preserved email
            }
        }
    }

    private func checkAndSubmit() async {
        guard newPass == confirmNew else {
            passMatch = false
            passMessage = "The passwords do not match."
            return
        }

        guard let url = URL(string: "http://192.168.1.18:8000/api/users/confirm-password-reset/") else {
            passMessage = "Invalid server URL."
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = [
            "email": email,
            "code": code,
            "new_password": newPass
        ]
        request.httpBody = try? JSONEncoder().encode(body)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                passMatch = true
                passMessage = "Password updated!"
                goNext = true
            } else {
                let decoded = try? JSONDecoder().decode([String: String].self, from: data)
                passMatch = false
                passMessage = decoded?["error"] ?? "Failed to reset password."
            }
        } catch {
            passMatch = false
            passMessage = "Network error. Try again."
        }
    }
}
