import Foundation

public struct Skill: Equatable, Identifiable {
    public var id: UUID = UUID()
    public let points: Double
    public let zoneType: ZoneType
}
