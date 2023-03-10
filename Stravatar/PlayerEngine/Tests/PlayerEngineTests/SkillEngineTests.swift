import XCTest
@testable import PlayerEngine

final class SkillEngineTests: XCTestCase {

    func test_heartRates_shouldReturn_mappedSkills() {
        let sut = createSUT()
        let skills = sut.getSkillsFor(heartRates: [150, 160, 120, 110], timeSample: 2.5)
        let expected = [
            Skill(points: 5.0, zoneType: .zone1),
            Skill(points: 2.5, zoneType: .zone2),
            Skill(points: 2.5, zoneType: .zone3),
            Skill(points: 0.0, zoneType: .zone4),
            Skill(points: 0.0, zoneType: .zone5)
        ]
        XCTAssertEqual(skills.map{ $0.points }, expected.map{ $0.points })
    }
    
    func test_activity_shouldAccumulate_skills() {
        let sut = createSUT()
        let skills = sut.getSkillsFor(heartRates: [150, 160, 120, 110], timeSample: 2.5)
        
        let expectedSkills = [
            Skill(points: 10.0, zoneType: .zone1),
            Skill(points: 5.0, zoneType: .zone2),
            Skill(points: 5.0, zoneType: .zone3),
            Skill(points: 0.0, zoneType: .zone4),
            Skill(points: 0.0, zoneType: .zone5)
        ]
        
        //when
        sut.earn(skills: skills)
        sut.earn(skills: skills)
        
        //then
        let playerSKills = sut.getPlayerSkills()
        let playerPoints = playerSKills.map { $0.points }
        let expectedPoints = expectedSkills.map { $0.points }
        XCTAssertEqual(playerPoints, expectedPoints)
        
    
    }
    
    private func createSUT() -> SkillEngine {
        let sut: SkillEngine = SkillEngineImpl()
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
