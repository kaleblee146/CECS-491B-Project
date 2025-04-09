//
//  RegistrationHelper.swift
//  moveMentorPhoneTest
//
//  Created by Kaleb Lee on 4/3/25.
//

import Foundation

struct RegisterRequest: Codable {
    let firstName: String
    let lastName: String
    let username: String
    let email: String
    let phone: String
    let dob: String
    let password: String
    let role: String
    let gender: String
    let age: Int
    let units: String
    let weight: Double
    let height: Double
    let goals: String
}

class RegisterAuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var userRole: String = ""
    
    var session: UserSession
    
    init(session: UserSession){
        self.session = session
    }
    
    func register(user: RegisterRequest){
        guard let url = URL(string: "http://127.0.0.1:8000/api/users/register/") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let bodyData = try JSONEncoder().encode(user)
            print("📤 Sending JSON: \(String(data: bodyData, encoding: .utf8) ?? "N/A")")
            request.httpBody = bodyData
        } catch {
            print("❌ Error encoding user: \(error)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Request error: \(error)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("📡 Status Code: \(httpResponse.statusCode)")
            }

            guard let data = data else {
                print("❌ No data received")
                return
            }

            print("📥 Raw response: \(String(data: data, encoding: .utf8) ?? "N/A")")

            do {
                let response = try JSONDecoder().decode(ProfileAuthResponse.self, from: data)
                DispatchQueue.main.async {
                    self.isAuthenticated = true
                    self.userRole = response.role
                    
                    self.session.id = response.id
                    self.session.username = response.username
                    self.session.firstName = response.firstName
                    self.session.lastName = response.lastName
                    self.session.role = response.role
                    self.session.isAuthenticated = true
                    
                    UserDefaults.standard.set(response.access, forKey: "access_token")
                    UserDefaults.standard.set(response.refresh, forKey: "refresh_token")
                }
            } catch {
                print("❌ Registration decode error: \(error)")
            }
        }.resume()
    }


}
