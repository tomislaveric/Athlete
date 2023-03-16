import XCTest
@testable import AvatarService

final class AvatarServiceTests: XCTestCase {

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
        sut.createAvatar(name: "Tomi")
        sut.update(skills: skills)
        sut.update(skills: skills)
        let player = sut.getAvatars()
        //then
        let playerPoints = player?.skills.map { $0.points }
        let expectedPoints = expectedSkills.map { $0.points }
        XCTAssertEqual(playerPoints, expectedPoints)
    }
    func test_getPlayer_shouldReturn_Nil_ifnoPlayerCreated() {
        let sut = createSUT()
        let player = sut.getAvatars()
        XCTAssertNil(player)
    }
    func test_createPlayer_shouldReturnPlayer_withInitialValues() {
        let sut = createSUT()
        sut.createAvatar(name: "Tomi")
        let expectedPlayer = sut.getAvatars()
        XCTAssertEqual(expectedPlayer?.age, 1)
        XCTAssertEqual(expectedPlayer?.name, "Tomi")
        XCTAssertEqual(expectedPlayer?.skills, [])
    }
    
    func test_setAge_shouldUpdatePlayer_withAge() {
        let sut = createSUT()
        let expectedPlayer = Avatar(name: "Tomi", age: 2)
        sut.createAvatar(name: "Tomi")
        sut.update(age: 2)
        let player = sut.getAvatars()
        XCTAssertEqual(player?.age, expectedPlayer.age)
    }
    
    private func createSUT() -> AvatarService {
        let sut: AvatarService = PlayerEngineImpl()
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
