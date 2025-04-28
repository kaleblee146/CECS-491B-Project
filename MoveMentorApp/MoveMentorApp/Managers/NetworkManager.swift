import Foundation

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
        guard let url = URL(string: "https://www.movementor.app/register/") else {
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

    // MARK: - Login User
    /// Logs in an existing user with username/password.
    func loginUser(username: String, password: String) async throws -> [String: Any] {
        //guard let url = URL(string: "http://127.0.0.1:8000/api/users/api/login/") else {
        //guard let url = URL(string: "http://localhost:8000/api/users/api/login/") else {
        guard let url = URL(string: "https://www.movementor.app/login/") else {
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
}
