import Foundation

public struct Avatar: Equatable, Codable {
    public init(id: UUID, name: String? = nil, age: Int? = nil, skills: [Skill]? = nil) {
        self.id = id
        self.name = name
        self.age = age
        self.skills = skills
    }
    
    public let id: UUID
    public let name: String?
    public let age: Int?
    public let skills: [Skill]?
}
