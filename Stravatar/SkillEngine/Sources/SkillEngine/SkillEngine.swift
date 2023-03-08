import Foundation

public protocol SkillEngine {
    typealias SEZoneType = ZoneType
    
    func setup(zones: [Zone])
    func getSkillsFor(heartRates: [Int], timeSample: Double) -> [Skill]
    func earn(skills: [Skill])
    func getPlayerSkills() -> [Skill]
}

public extension SkillEngine {
    func getSkillsFor(heartRates: [Int]) -> [Skill] {
        getSkillsFor(heartRates: heartRates, timeSample: 1)
    }
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

public struct Skill: Equatable, Identifiable {
    public var id: Int = UUID().hashValue
    public let points: Double
    public let zoneType: ZoneType
}

public struct Zone: Equatable, Identifiable {
    public var id: Int = UUID().hashValue
    public let range: Range<Int>
    public let type: ZoneType
    
    public init(range: Range<Int>, type: ZoneType) {
        self.range = range
        self.type = type
    }
}

public enum ZoneType: String, Equatable, Identifiable, CaseIterable {
    public var id: Self {
        return self
    }
    case zone1
    case zone2
    case zone3
    case zone4
    case zone5
}
