import Foundation

public protocol SkillEngine {
    typealias SEZoneType = ZoneType
    
    func setup(zones: [Zone])
    func getSkillsFor(heartRates: [Int], timeSample: Double) -> [Skill]
    func earn(skills: [Skill])
    func getPlayerSkills() -> [Skill]
}

public class SkillEngineImpl: SkillEngine {
    private var playerSkills: [Skill] = []
    
    public func getPlayerSkills() -> [Skill] {
        return playerSkills
    }
    
    public func earn(skills: [Skill]) {
        self.playerSkills = skills.map { new in
            guard let player: Skill = self.playerSkills.first(where: { player in player.zoneType == new.zoneType }) else {
                return Skill(points: new.points, zoneType: new.zoneType)
            }
            return Skill(points: new.points + player.points, zoneType: new.zoneType)
        }
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

public extension SkillEngine {
    func getSkillsFor(heartRates: [Int]) -> [Skill] {
        getSkillsFor(heartRates: heartRates, timeSample: 1)
    }
}

