import XCTest
@testable import SkillEngine

final class SkillEngineTests: XCTestCase {
//    func test_zones_shouldReturn_correctValues() throws {
//        
//        let sut = createSUT()
//        let pointsZone1 = sut.getPointsFor(heartRate: 77)
//        let pointsZone2 = sut.getPointsFor(heartRate: 138)
//        let pointsZone3 = sut.getPointsFor(heartRate: 160)
//        let pointsZone4 = sut.getPointsFor(heartRate: 188)
//        let pointsZone5 = sut.getPointsFor(heartRate: 250)
//        
//        XCTAssertEqual(pointsZone1, 100)
//        XCTAssertEqual(pointsZone2, 200)
//        XCTAssertEqual(pointsZone3, 300)
//        XCTAssertEqual(pointsZone4, 400)
//        XCTAssertEqual(pointsZone5, 500)
//    }
    
    func test_heartRates_shouldReturn_mappedSkills() {
        let sut = createSUT()
        let skills = sut.getSkillsFor(heartRates: [150, 160, 120, 110], timeSample: 2.5)
        let expected = [
            Skill(points: 575, zoneType: .zone1),
            Skill(points: 375, zoneType: .zone2),
            Skill(points: 400, zoneType: .zone3),
            Skill(points: 0, zoneType: .zone4),
            Skill(points: 0, zoneType: .zone5)
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
