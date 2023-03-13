import Foundation
import HTTPRequest

public protocol PlayerEngine {
    typealias PlayerZoneType = ZoneType
    
    func setup(zones: [Zone])
    func getSkillsFor(heartRates: [Int], timeSample: Double) -> [Skill]
    
    func getPlayer() async throws -> Player?
    func createPlayer(name: String) async throws -> Player
    func update(id: UUID, skills: [Skill]) async throws -> Player
    func update(id: UUID, age: Int) async throws -> Player
    func update(id: UUID, name: String) async throws -> Player
}

public class PlayerEngineImpl: PlayerEngine {
    public func update(id: UUID, age: Int) async throws -> Player {
        guard let baseURL, let url = URL(string: "\(baseURL)/player") else {
            throw PlayerEngineError.endpointURLWrong
        }
        return try await httpRequest.put(url: url, header: nil, body: Player(id: id, age: age))
    }
    
    public func update(id: UUID, name: String) async throws -> Player {
        guard let baseURL, let url = URL(string: "\(baseURL)/player") else {
            throw PlayerEngineError.endpointURLWrong
        }
        return try await httpRequest.put(url: url, header: nil, body: Player(id: id, name: name))
    }
    
    public func update(id: UUID, skills: [Skill]) async throws -> Player {
        guard let baseURL, let url = URL(string: "\(baseURL)/player") else {
            throw PlayerEngineError.endpointURLWrong
        }
        return try await httpRequest.put(url: url, header: nil, body: Player(id: id, skills: skills))
    }
    
    public func createPlayer(name: String) async throws -> Player {
        let player = Player(id: UUID(), name: name)

        guard let baseURL, let url = URL(string: "\(baseURL)/player") else {
            throw PlayerEngineError.endpointURLWrong
        }
        return try await httpRequest.post(url: url, header: nil, body: player)
    }
    
    public func getPlayer() async throws -> Player? {
        guard let baseURL, let url = URL(string: "\(baseURL)/player") else {
            throw PlayerEngineError.endpointURLWrong
        }
        return try await httpRequest.get(url: url, header: nil)
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
    
    public init(httpRequest: HTTPRequest = HTTPRequestImpl(), baseURL: String) {
        self.httpRequest = httpRequest
        self.baseURL = URL(string: baseURL)
    }
    
    private var baseURL: URL?
    private let httpRequest: HTTPRequest
    
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
    case endpointURLWrong
}
