import XCTest
@testable import Interval

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
        XCTAssertEqual(timer.progress(), 1.0)
    }

    func testPauseResume() {
        let timer = PomodoroTimer.init()
        timer.pause()
        timer.resume()
    }

    func testUpdateWithoutStageChange() {
        let timer = PomodoroTimer.init()
        let newStage = timer.update(date: Date.init(timeIntervalSinceNow: 10 * 60.0))
        XCTAssertEqual(newStage, PomodoroTimer.Stage.Work)
    }

    func testUpdateToShortBreak() {
        let timer = PomodoroTimer.init()
        let newStage = timer.update(date: Date.init(timeIntervalSinceNow: 26 * 60.0))
        XCTAssertEqual(newStage, PomodoroTimer.Stage.ShortBreak)
    }

    func testUpdateToLongBreak() {
        let timer = PomodoroTimer.init()

        XCTAssertEqual(.ShortBreak, timer.update(date: Date.init(timeIntervalSinceNow: 26 * 60.0)))
        XCTAssertEqual(.Work, timer.update(date: Date.init(timeIntervalSinceNow: 26 * 60.0)))

        XCTAssertEqual(.ShortBreak, timer.update(date: Date.init(timeIntervalSinceNow: 26 * 60.0)))
        XCTAssertEqual(.Work, timer.update(date: Date.init(timeIntervalSinceNow: 26 * 60.0)))

        XCTAssertEqual(.ShortBreak, timer.update(date: Date.init(timeIntervalSinceNow: 26 * 60.0)))
        XCTAssertEqual(.Work, timer.update(date: Date.init(timeIntervalSinceNow: 26 * 60.0)))

        XCTAssertEqual(.LongBreak, timer.update(date: Date.init(timeIntervalSinceNow: 26 * 60.0)))
        XCTAssertEqual(.Work, timer.update(date: Date.init(timeIntervalSinceNow: 26 * 60.0)))
    }
}
