import Foundation

public struct Zone: Equatable, Identifiable {
    public var id: Int = UUID().hashValue
    public let range: Range<Int>
    public let type: ZoneType
    
    public init(range: Range<Int>, type: ZoneType) {
        self.range = range
        self.type = type
    }
}
