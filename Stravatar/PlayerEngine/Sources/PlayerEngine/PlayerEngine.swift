import Foundation

public protocol PlayerEngine {
    typealias PlayerZoneType = ZoneType
    
    func setup(zones: [Zone])
    func getSkillsFor(heartRates: [Int], timeSample: Double) -> [Skill]
    
    func getPlayer() -> Player?
    func createPlayer(name: String) -> Player
    func update(skills: [Skill]) throws -> Player
    func update(age: Int) throws -> Player
    func update(name: String) throws -> Player
}

public class PlayerEngineImpl: PlayerEngine {
    public func update(age: Int) throws -> Player {
        try updatePlayer(age: age)
    }
    
    public func update(name: String) throws -> Player {
        try updatePlayer(name: name)
    }
    
    public func update(skills: [Skill]) throws -> Player {
        let skills = skills.map { new in
            guard let player: Skill = self.player?.skills.first(where: { player in player.zoneType == new.zoneType }) else {
                return Skill(points: new.points, zoneType: new.zoneType)
            }
            return Skill(points: new.points + player.points, zoneType: new.zoneType)
        }
        return try updatePlayer(skills: skills)
    }
    
    public func createPlayer(name: String) -> Player {
        let player = Player(name: name, skills: [
            Skill(points: 0, zoneType: .zone2),
            Skill(points: 0, zoneType: .zone3),
            Skill(points: 0, zoneType: .zone4),
            Skill(points: 0, zoneType: .zone5)
        ])
        self.player = player
        return player
    }
    
    public func getPlayer() -> Player? {
        return self.player
    }
    
    public func getSkillsFor(heartRates: [Int], timeSample: Double) -> [Skill] {
        return ZoneType.allCases.compactMap { zone in
            Skill(points: getTimeSpent(in: zone, for: heartRates, timeSample: timeSample),
                  zoneType: zone)
        }
    }
    
    public func setup(zones: [Zone]) {
        self.userZones = zones
    }
    
    public init() {}
    
    private var player: Player?
    
    private func updatePlayer(name: String? = nil, age: Int? = nil, skills: [Skill]? = nil) throws -> Player {
        guard let player else { throw PlayerEngineError.updateFailed }
        let updatedPlayer = Player(
            name: name ?? player.name,
            age: age ?? player.age,
            skills: skills ?? player.skills
        )
        self.player = updatedPlayer
        return updatedPlayer
    }
    
    private func getTimeSpent(in zone: ZoneType, for heartRates: [Int], timeSample: Double = 1) -> Double {
        Double(heartRates.filter { getHrZoneType(heartRate: $0) == zone }.count) * timeSample
    }
    
    private func getHrZoneType(heartRate: Int) -> ZoneType? {
        guard let zoneType = self.userZones?.first(where: { $0.range.contains(heartRate) })?.type else {
            return nil
        }
        return zoneType
    }
    
    private var userZones: [Zone]?
}

//MARK: Default implementations

public extension PlayerEngine {
    func getSkillsFor(heartRates: [Int]) -> [Skill] {
        getSkillsFor(heartRates: heartRates, timeSample: 1)
    }
}

enum PlayerEngineError: Error {
    case updateFailed
}
