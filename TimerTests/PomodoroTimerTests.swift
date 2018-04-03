import XCTest

@testable import Timer

class PomodoroTimerTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testInit() {
        let timer = PomodoroTimer.init()
        XCTAssertEqual(timer.stage, PomodoroTimer.Stage.Work)
    }

    func testUpdateWithoutStageChange() {
        let timer = PomodoroTimer.init()
        let newStage = timer.update(date: Date.init(timeIntervalSinceNow: 10 * 60.0))
        XCTAssertEqual(newStage, PomodoroTimer.Stage.Work)
    }
}