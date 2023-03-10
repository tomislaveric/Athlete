import Foundation

public protocol PlayerEngine {
    typealias SEZoneType = ZoneType
    
    func setup(zones: [Zone])
    func getSkillsFor(heartRates: [Int], timeSample: Double) -> [Skill]
    
    func getPlayer() -> Player?
    func createPlayer(name: String) -> Player
    func update(skills: [Skill])
    func update(age: Int)
    func update(name: String)
}

public class PlayerEngineImpl: PlayerEngine {
    public func update(age: Int) {
        updatePlayer(age: age)
    }
    
    public func update(name: String) {
        updatePlayer(name: name)
    }
    
    public func update(skills: [Skill]) {
        let skills = skills.map { new in
            guard let player: Skill = self.player?.skills.first(where: { player in player.zoneType == new.zoneType }) else {
                return Skill(points: new.points, zoneType: new.zoneType)
            }
            return Skill(points: new.points + player.points, zoneType: new.zoneType)
        }
        updatePlayer(skills: skills)
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
    
    private func updatePlayer(name: String? = nil, age: Int? = nil, skills: [Skill]? = nil) {
        guard let player else { return }
        self.player = Player(
            name: name ?? player.name,
            age: age ?? player.age,
            skills: skills ?? player.skills
        )
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

