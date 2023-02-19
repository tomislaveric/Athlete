import Foundation

public protocol SkillEngine {
    typealias SEZoneType = ZoneType
    
    func setup(zones: [Zone])
    func getSkillsFor(heartRates: [Int], timeSample: Double?) -> [Skill]
}

public extension SkillEngine {
    func getSkillsFor(heartRates: [Int]) -> [Skill] {
        getSkillsFor(heartRates: heartRates, timeSample: 1)
    }
}

public class SkillEngineImpl: SkillEngine {
    public func getSkillsFor(heartRates: [Int], timeSample: Double?) -> [Skill] {
        return ZoneType.allCases.map { zone in
            Skill(points: heartRates
                .filter { getHrZoneType(heartRate: $0) == zone }
                .map { Double($0) }
                .reduce(0) {
                    ($0+$1*(timeSample ?? 1) )}, zoneType: zone)
        }
    }
    public func setup(zones: [Zone]) {
        self.userZones = zones
    }
    
    public init() {}
    
    private func getHrZoneType(heartRate: Int) -> ZoneType? {
        guard let zoneType = self.userZones?.first(where: { $0.range.contains(heartRate) })?.type else {
            return nil
        }
        return zoneType
    }
    
    private var userZones: [Zone]?
}

public struct Skill: Equatable {
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
