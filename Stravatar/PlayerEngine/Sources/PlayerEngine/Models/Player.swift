import Foundation

public struct Player: Equatable {
    public init(name: String, age: Int = 1, skills: [Skill] = []) {
        self.name = name
        self.age = age
        self.skills = skills
    }
    private(set) var id = UUID()
    private(set) var name: String
    private(set) var age: Int
    private(set) var skills: [Skill]
}
