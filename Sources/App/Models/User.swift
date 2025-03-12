import Vapor
import Fluent

final class User: Model, Content {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password_hash")
    var passwordHash: String
    
    init() { }
    
    init(id: UUID? = nil, email: String, passwordHash: String) {
        self.id = id
        self.email = email
        self.passwordHash = passwordHash
    }
}

// Public representation for responses (excluding sensitive data)
extension User {
    struct Public: Content {
        var id: UUID?
        var email: String
    }
    
    func asPublic() -> Public {
        Public(id: id, email: email)
    }
}
