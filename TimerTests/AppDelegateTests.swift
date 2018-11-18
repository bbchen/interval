import XCTest
@testable import Interval

class AppDelegateTests: XCTestCase {
    func testInit() {
        let delegate = AppDelegate.init()
        XCTAssertNotNil(delegate)
    }
}
