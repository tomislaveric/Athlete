import Foundation

public struct Player: Equatable {
    public init(name: String, age: Int = 1, skills: [Skill] = []) {
        self.name = name
        self.age = age
        self.skills = skills
    }
    private(set) var id = UUID()
    public let name: String
    public let age: Int
    public let skills: [Skill]
}
