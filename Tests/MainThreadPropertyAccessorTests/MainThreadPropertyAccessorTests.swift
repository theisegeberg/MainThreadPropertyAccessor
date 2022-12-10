@testable import MainThreadPropertyAccessor
import XCTest

final class MainThreadPropertyAccessorTests: XCTestCase {
    
    /// Tests that setting a value acts as expected.
    func testSettingValue() {
        class ATestObject: MainThreadPropertyAccessor {
            var aWritableProperty: String = "An initial value"

            init() {}
        }

        let anObject = ATestObject()
        anObject.setOnMain.aWritableProperty = "A new value"
        /// Because the value is set on the main dispatch queue asynchronously
        /// it won't  get changed immediately, here I simply verify that fact.
        XCTAssert(anObject.aWritableProperty == "An initial value")

        /// To test that it's set later we'll schedule the next assertion to happen asynchronously
        /// on the main dispatch queue.
        let expectation = XCTestExpectation()
        DispatchQueue.main.async {
            XCTAssert(anObject.aWritableProperty == "A new value")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    /// Tests that getting a value acts as expected.
    func testNilSetting() {
        class ATestObject: MainThreadPropertyAccessor {
            var aWritableProperty: String? = "An initial value"
            
            init() {}
        }
        let anObject = ATestObject()
        anObject.setOnMain.aWritableProperty = nil

        let expectation = XCTestExpectation()
        DispatchQueue.main.async {
            XCTAssert(anObject.aWritableProperty == nil)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)

    }
}
