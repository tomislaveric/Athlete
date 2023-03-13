import Foundation

public enum ZoneType: String, Equatable, Identifiable, CaseIterable, Codable {
    public var id: Self {
        return self
    }
    public var name: String {
        switch self {
        case .zone1: return ""
        case .zone2: return "Health"
        case .zone3: return "Endurance"
        case .zone4: return "Speed"
        case .zone5: return "Strength"
        }
    }
    case zone1
    case zone2
    case zone3
    case zone4
    case zone5
}
