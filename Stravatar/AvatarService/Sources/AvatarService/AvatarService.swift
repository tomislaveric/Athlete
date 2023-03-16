import Foundation
import HTTPRequest

public protocol AvatarService {
    typealias PlayerZoneType = ZoneType
    
    func setup(zones: [Zone])
    func getSkillsFor(heartRates: [Int], timeSample: Double) -> [Skill]
    
    func getAvatars() async throws -> Avatar?
    func createAvatar(name: String) async throws -> Avatar
    func update(id: UUID, skills: [Skill]) async throws -> Avatar
    func update(id: UUID, age: Int) async throws -> Avatar
    func update(id: UUID, name: String) async throws -> Avatar
}

public class AvatarServiceImpl: AvatarService {
    public func update(id: UUID, age: Int) async throws -> Avatar {
        return try await httpRequest.put(url: getAvatarUrl(), header: nil, body: Avatar(id: id, age: age))
    }
    
    public func update(id: UUID, name: String) async throws -> Avatar {
        return try await httpRequest.put(url: getAvatarUrl(), header: nil, body: Avatar(id: id, name: name))
    }
    
    public func update(id: UUID, skills: [Skill]) async throws -> Avatar {
        return try await httpRequest.put(url: getAvatarUrl(), header: nil, body: Avatar(id: id, skills: skills))
    }
    
    public func createAvatar(name: String) async throws -> Avatar {
        let player = Avatar(id: UUID(), name: name)
        return try await httpRequest.post(url: getAvatarUrl(), header: nil, body: player)
    }
    
    public func getAvatars() async throws -> Avatar? {
        return try await httpRequest.get(url: getAvatarUrl(), header: nil)
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
    
    private func getAvatarUrl() throws -> URL {
        guard let baseURL, let url = URL(string: "\(baseURL)/avatar") else {
            throw PlayerEngineError.endpointURLWrong
        }
        return url
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

public extension AvatarService {
    func getSkillsFor(heartRates: [Int]) -> [Skill] {
        getSkillsFor(heartRates: heartRates, timeSample: 1)
    }
}

enum PlayerEngineError: Error {
    case updateFailed
    case endpointURLWrong
}
