import XCTest
@testable import SkillEngine

final class SkillEngineTests: XCTestCase {

    func test_heartRates_shouldReturn_mappedSkills() {
        let sut = createSUT()
        let skills = sut.getSkillsFor(heartRates: [150, 160, 120, 110], timeSample: 2.5)
        let expected = [
            Skill(points: 575.0, zoneType: .zone1),
            Skill(points: 375.0, zoneType: .zone2),
            Skill(points: 400.0, zoneType: .zone3),
            Skill(points: 0.0, zoneType: .zone4),
            Skill(points: 0.0, zoneType: .zone5)
        ]
        XCTAssertEqual(skills, expected)
    }
    
    private func createSUT() -> SkillEngine {
        let sut = SkillEngineImpl()
        sut.setup(zones: [
            Zone(range: 0..<138, type: .zone1),
            Zone(range: 138..<159, type: .zone2),
            Zone(range: 159..<179, type: .zone3),
            Zone(range: 179..<189, type: .zone4),
            Zone(range: 177..<197, type: .zone5),
        ])
        return sut
    }
}
