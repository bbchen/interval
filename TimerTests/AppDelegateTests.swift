import XCTest
@testable import Interval

class AppDelegateTests: XCTestCase {
    func testInit() {
        let delegate = AppDelegate.init()
        XCTAssertNotNil(delegate)
    }

    func testStartTimer() {
        let delegate = AppDelegate.init()
        delegate.startTimer()
        delegate.startTimer()
    }

    func testStopTimer() {
        let delegate = AppDelegate.init()
        delegate.stopTimer()
        delegate.stopTimer()
    }
}
