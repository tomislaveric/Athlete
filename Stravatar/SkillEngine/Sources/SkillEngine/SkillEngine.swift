import Foundation

public protocol SkillEngine {
    typealias SEZoneType = ZoneType
    
    func setup(zones: [Zone])
    func getPointsFor(heartRate: Int) -> Int
}

public class SkillEngineImpl: SkillEngine {
    public init() {}
    
    public func setup(zones: [Zone]) {
        self.userZones = zones
    }
    
    public func getPointsFor(heartRate: Int) -> Int {
        guard let zoneType = self.userZones?.first(where: { $0.range.contains(heartRate) })?.type else {
            return 0
        }
        
       return getPointsFor(zoneType: zoneType)
    }
    
    func getPointsFor(zoneType: ZoneType) -> Int {
        switch zoneType {
        case .zone1: return 100
        case .zone2: return 200
        case .zone3: return 300
        case .zone4: return 400
        case .zone5: return 500
        case .none: return 0
        }
    }
    
    private var userZones: [Zone]?
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

public enum ZoneType: String, Equatable, Identifiable {
    public var id: Self {
        return self
    }
    case zone1
    case zone2
    case zone3
    case zone4
    case zone5
    case none
}
