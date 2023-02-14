import XCTest
@testable import SkillEngine

final class SkillEngineTests: XCTestCase {
    func test_zones_shouldReturn_correctValues() throws {
        
        let sut = createSUT()
        let pointsZone1 = sut.getPointsFor(heartRate: 77)
        let pointsZone2 = sut.getPointsFor(heartRate: 138)
        let pointsZone3 = sut.getPointsFor(heartRate: 160)
        let pointsZone4 = sut.getPointsFor(heartRate: 188)
        let pointsZone5 = sut.getPointsFor(heartRate: 250)
        
        XCTAssertEqual(pointsZone1, 100)
        XCTAssertEqual(pointsZone2, 200)
        XCTAssertEqual(pointsZone3, 300)
        XCTAssertEqual(pointsZone4, 400)
        XCTAssertEqual(pointsZone5, 500)
    }
    
    private func createSUT() -> SkillEngine {
        let sut = SkillEngineImpl()
        sut.setup(zone1: 0..<138, zone2: 138..<159, zone3: 159..<179, zone4: 179..<189, zone5: 177..<197)
        return sut
    }
}
