import Foundation
import HTTPRequest
import SharedModels

public protocol AvatarService {   
    func setup(zones: [Zone])
    func getSkillsFor(heartRates: [Int], timeSample: Double) -> [Skill]
    
    func getAvatars() async throws -> [Avatar]
    func createAvatar(name: String) async throws -> Avatar
    func update(avatar: Avatar) async throws -> Avatar
}

public class AvatarServiceImpl: AvatarService {
    public func update(avatar: Avatar) async throws -> Avatar {
        guard let id = avatar.id else {
            throw AvatarServiceError.updateFailed
        }
        return try await httpRequest.patch(url: updateAvatarUrl(id: id), header: nil, body: avatar)
    }
    
    public func createAvatar(name: String) async throws -> Avatar {
        let player = Avatar(name: name)
        return try await httpRequest.post(url: avatarUrl(), header: nil, body: player)
    }
    
    public func getAvatars() async throws -> [Avatar] {
        return try await httpRequest.get(url: avatarsUrl(), header: nil)
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
    
    private func avatarsUrl() throws -> URL {
        guard let baseURL, let url = URL(string: "\(baseURL)/avatars") else {
            throw AvatarServiceError.endpointURLWrong
        }
        return url
    }
    
    private func updateAvatarUrl(id: UUID) throws -> URL {
        guard let baseURL, let url = URL(string: "\(baseURL)/avatar/\(id)") else {
            throw AvatarServiceError.endpointURLWrong
        }
        return url
    }
    
    private func avatarUrl() throws -> URL {
        guard let baseURL, let url = URL(string: "\(baseURL)/avatar") else {
            throw AvatarServiceError.endpointURLWrong
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

enum AvatarServiceError: Error {
    case updateFailed
    case endpointURLWrong
}
