import Foundation

class OpenAIService {
    static let shared = OpenAIService()
    private let apiKey = SecretsManager.shared.get("OPENAI_API_KEY") ?? ""

    func getFeedback(prompt: String) async throws -> String {
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "system", "content": "You are a fitness coach giving positive, clear advice."],
                ["role": "user", "content": prompt]
            ],
            "temperature": 0.7
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)

        
        if let json = try? JSONSerialization.jsonObject(with: data, options: []),
        let prettyData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
        let prettyString = String(data: prettyData, encoding: .utf8) {
            print("🔍 OpenAI Response:\n\(prettyString)")
        } else {
            print("⚠️ Received non-JSON response: \(String(data: data, encoding: .utf8) ?? "nil")")
        }

       
        let decoded = try JSONDecoder().decode(OpenAIResponse.self, from: data)
        return decoded.choices.first?.message.content ?? "No feedback available."
    }

}

struct OpenAIResponse: Codable {
    struct Choice: Codable {
        let message: Message
    }

    struct Message: Codable {
        let role: String
        let content: String
    }

    let choices: [Choice]
}
