//
//  CreateUserHelper.swift
//  moveMentorPhoneTest
//
//  Created by Kaleb Lee on 4/2/25.
//

import Foundation

struct LoginAuthResponse: Codable {
    let id: Int?
    let username: String
    let email: String
    let firstName: String
    let lastName: String
    let role: String
    let age: Int?
    let height: Double?
    let weight: Double?
    let access: String
    let refresh: String
    let date_joined: String?
}


class LoginAuthViewModel: ObservableObject{
    @Published var isAuthenticated = false
    @Published var userRole: String = ""
    
    var session: UserSession
    
    init(session: UserSession){
        self.session = session
    }
    func socialLogin(idToken: String, provider: String) {
        //test guard let url = URL(string: "http://127.0.0.1:8000/api/users/social-login/") else { return }
        guard let url = URL(string: "http://52.53.157.43:8000/api/login/") else { return }
                let body: [String: String] = [
                    "id_token": idToken,
                    "provider": provider
                ]

                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")

                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
                } catch {
                    print("Failed to encode social login request: \(error)")
                    return
                }

                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print("❌ Social login error: \(error.localizedDescription)")
                        return
                    }

                    guard let data = data else {
                        print("❌ No data received from social login")
                        return
                    }

                    print("📥 Social login response: \(String(data: data, encoding: .utf8) ?? "N/A")")

                    do {
                        let response = try JSONDecoder().decode(LoginAuthResponse.self, from: data)

                        DispatchQueue.main.async {
                            self.session.id = response.id
                            self.session.username = response.username
                            self.session.firstName = response.firstName
                            self.session.lastName = response.lastName
                            self.session.age = response.age
                            self.session.weight = response.weight
                            self.session.height = response.height
                            self.session.role = response.role
                            self.session.isAuthenticated = true

                            if let dateString = response.date_joined {
                                let formatter = ISO8601DateFormatter()
                                if let date = formatter.date(from: dateString) {
                                    self.session.joinedYear = Calendar.current.component(.year, from: date)
                                }
                            }

                            UserDefaults.standard.set(response.access, forKey: "access_token")
                            UserDefaults.standard.set(response.refresh, forKey: "refresh_token")
                        }
                    } catch {
                        print("❌ Failed to decode social login response: \(error)")
                    }
                }.resume()
            }
    
    
    func login(username: String, password: String){
        guard let url = URL(string: "http://127.0.0.1:8000/api/users/login/") else { return }
        
        let body: [String: String] = [
            "username": username,
            "password": password
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Failed to decode request body: \(error)")
            return
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Network error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("❌ No data received from server")
                return
            }
            
            // 🔍 Print the raw response
            print("📥 Raw login response: \(String(data: data, encoding: .utf8) ?? "N/A")")
            
            do {
                let response = try JSONDecoder().decode(LoginAuthResponse.self, from: data)
                print("✅ Successfully decoded login response")
                print("🧠 User: \(response.firstName) \(response.lastName), Role: \(response.role)")
                
                DispatchQueue.main.async {
                    self.session.id = response.id
                    self.session.username = response.username
                    self.session.firstName = response.firstName
                    self.session.lastName = response.lastName
                    self.session.age = response.age
                    self.session.weight = response.weight
                    self.session.height = response.height
                    self.session.role = response.role
                    self.session.isAuthenticated = true
                    
                    if let dateString = response.date_joined {
                        let formatter = ISO8601DateFormatter()
                        if let date = formatter.date(from: dateString){
                            self.session.joinedYear = Calendar.current.component(.year, from: date)
                        }
                    }
                    
                    UserDefaults.standard.set(response.access, forKey: "access_token")
                    UserDefaults.standard.set(response.refresh, forKey: "refresh_token")
                }
            } catch {
                print("❌ Login decode error: \(error.localizedDescription)")
            }
        }.resume()
    }
}

