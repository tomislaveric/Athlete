public protocol SkillEngine {
    func setup(zone1: Range<Int>, zone2: Range<Int>, zone3: Range<Int>, zone4: Range<Int>, zone5: Range<Int>)
    func getPointsFor(heartRate: Int) -> Int
}

public class SkillEngineImpl: SkillEngine {
    public func setup(zone1: Range<Int>, zone2: Range<Int>, zone3: Range<Int>, zone4: Range<Int>, zone5: Range<Int>) {
        self.userZones = [
            Zone(range: zone1, type: .zone1),
            Zone(range: zone2, type: .zone2),
            Zone(range: zone3, type: .zone3),
            Zone(range: zone4, type: .zone4),
            Zone(range: zone5.lowerBound..<Int.max, type: .zone5)
        ]
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
        }
    }
    
    private var userZones: [Zone]?
}

struct Zone {
    let range: Range<Int>
    let type: ZoneType
}

enum ZoneType {
    case zone1
    case zone2
    case zone3
    case zone4
    case zone5
}
