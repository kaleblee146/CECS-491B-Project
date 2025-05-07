//This is going to be 

import Foundation

class SecretsManager {
    static let shared = SecretsManager()

    private var secrets: [String: Any] = [:]

    private init() {
        guard let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist") else {
            fatalError("❌ Secrets.plist not found in bundle.")
        }

        do {
            let data = try Data(contentsOf: url)
            if let plist = try PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any] {
                self.secrets = plist
            } else {
                fatalError("❌ Failed to parse Secrets.plist as dictionary.")
            }
        } catch {
            fatalError("❌ Error loading Secrets.plist: \(error.localizedDescription)")
        }
    }

    func get(_ key: String) -> String? {
        return secrets[key] as? String
    }
}