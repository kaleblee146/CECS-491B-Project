import Foundation
import SwiftUI

enum NetworkError: Error {
    case invalidURL
    case badStatusCode(Int)
    case parsingError
}

/// A singleton class for handling all network requests.
class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {} // Enforce singleton usage

    // MARK: - Register User
    /// Registers a new user with all fields from CustomUser.
    func registerUser(
        username: String,
        password: String,
        firstName: String,
        lastName: String,
        dob: String,
        email: String,
        phone: String,
        gender: String,
        age: Int,
        units: String,
        weight: Double,
        height: Double,
        goals: String,
        bio: String,
        role: String
        // profile_picture, if applicable, might need special handling
    ) async throws -> [String: Any] {
        
        // 1) Construct URL
       // guard let url = URL(string: "https://www.movementor.app/register/") else {
        
        guard let url = URL(string: "http://192.168.1.18:8000/api/register/") else {

        //guard let url = URL(string: "http://127.0.0.1:8000/api/register/") else {
        //guard let url = URL(string: "https://e4a5-2607-fb91-8823-90a0-3db4-904a-247d-7d8d.ngrok-free.app/api/login/") else {

            throw NetworkError.invalidURL
        }
        
        // 2) Prepare JSON body
        //   Make sure these field names match exactly what your Django serializer expects.
        let requestBody: [String: Any] = [
            "username": username,
            "password": password,
            "firstName": firstName,
            "lastName": lastName,
            "dob": dob,
            "email": email,
            "phone": phone,
            "gender": gender,
            "age": age,
            "units": units,
            "weight": weight,
            "height": height,
            "goals": goals,
            "bio": bio,
            "role": role
            // "profile_picture": ??? // Typically needs multipart if uploading an actual image
        ]
        
        // 3) Create URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        // 4) Perform request with URLSession
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // 5) Check HTTP status code
        if let httpResponse = response as? HTTPURLResponse,
           !(200...299).contains(httpResponse.statusCode) {
            throw NetworkError.badStatusCode(httpResponse.statusCode)
        }
        
        // 6) Parse JSON response
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
        guard let jsonDict = jsonObject as? [String: Any] else {
            throw NetworkError.parsingError
        }
        
        return jsonDict
    }
    
    func registerUser(from data: RegistrationData) async throws -> [String: Any] {
            try await registerUser(
                username: data.username,
                password: data.password,
                firstName: data.firstName,
                lastName: data.lastName,
                dob: DateFormatter.shortDateFormatter.string(from: data.dob),
                email: data.email,
                phone: data.phone,
                gender: data.gender,
                age: data.age,
                units: data.units,
                weight: data.weight,
                height: data.height,
                goals: data.goals,
                bio: data.bio,
                role: data.role
            )
        }
    

    // MARK: - Login User
    /// Logs in an existing user with username/password.
    func loginUser(username: String, password: String) async throws -> [String: Any] {
        //guard let url = URL(string: "https://10.39.78.132:8000/api/login/"
//) else {
        guard let url = URL(string: "http://192.168.1.18:8000/api/login/") else {

        //guard let url = URL(string: "http://127.0.0.1:8000/api/login/") else {
        //guard let url = URL(string: "https://www.movementor.app/login/") else {
        //guard let url = URL(string: "https://e4a5-2607-fb91-8823-90a0-3db4-904a-247d-7d8d.ngrok-free.app/api/login/") else {
            throw NetworkError.invalidURL
        }
        
        let requestBody: [String: Any] = [
            "username": username,
            "password": password
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse,
           !(200...299).contains(httpResponse.statusCode) {
            throw NetworkError.badStatusCode(httpResponse.statusCode)
        }
        
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
        guard let jsonDict = jsonObject as? [String: Any] else {
            throw NetworkError.parsingError
        }
        
        return jsonDict
    }
    
    func uploadProfileImage(image: UIImage, username: String) async throws {
        guard let url = URL(string: "http://192.168.1.18:8000/api/upload-profile-picture/") else {

        //guard let url = URL(string: "https://127.0.0.1:8000/api/upload-profile-picture/") else {
            throw NetworkError.invalidURL
        }

        let boundary = UUID().uuidString
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()

        // Add username (or auth token, depending on your auth flow)
        let usernameData = "--\(boundary)\r\n"
            + "Content-Disposition: form-data; name=\"username\"\r\n\r\n"
            + "\(username)\r\n"
        data.append(Data(usernameData.utf8))

        // Convert UIImage to JPEG data
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw NetworkError.parsingError
        }

        // Add image
        data.append(Data("--\(boundary)\r\n".utf8))
        data.append(Data("Content-Disposition: form-data; name=\"profile_picture\"; filename=\"profile.jpg\"\r\n".utf8))
        data.append(Data("Content-Type: image/jpeg\r\n\r\n".utf8))
        data.append(imageData)
        data.append(Data("\r\n".utf8))

        data.append(Data("--\(boundary)--\r\n".utf8))
        request.httpBody = data

        let (_, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse,
           !(200...299).contains(httpResponse.statusCode) {
            throw NetworkError.badStatusCode(httpResponse.statusCode)
        }
    }

}

class RegistrationData: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var dob: Date = Date()
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var gender: String = ""
    @Published var age: Int = 0
    @Published var units: String = ""
    @Published var weight: Double = 0.0
    @Published var height: Double = 0.0
    @Published var goals: String = ""
    @Published var bio: String = ""
    @Published var role: String = "Free" // Default role maybe
}

class UserSession: ObservableObject {
    @Published var isLoggedIn: Bool = true
    @Published var username: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var role: String = ""
    @Published var height: Double = 0.0
    @Published var weight: Double = 0.0
    @Published var age: Int = 0
    @Published var joinedYear: Int = Calendar.current.component(.year, from: Date())
    @Published var isAuthenticated: Bool = false
    @Published var profileImage: Image? = nil
    @Published var rawProfileUIImage: UIImage? = nil
    @Published var profileImageURL: String = ""
    
    func logout() {
            isLoggedIn = false
            username = ""
            phone = ""
            // Optionally clear auth token
            UserDefaults.standard.removeObject(forKey: "authToken")
        }


}

extension DateFormatter {
    static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // 2025-04-27 style
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
