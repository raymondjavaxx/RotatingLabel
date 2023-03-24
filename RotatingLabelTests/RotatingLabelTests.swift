//
//  RotatingLabelTests.swift
//  RotatingLabelTests
//
//  Created by Ramon Torres on 3/23/23.
//

import XCTest
import RotatingLabel

final class RotatingLabelTests: XCTestCase {

    func test_value_shouldSetAccessibilityLabel() {
        let sut = makeSUT()
        sut.text = "$250.00"
        XCTAssertEqual(sut.accessibilityLabel, "$250.00")
    }

    func test_setValue_shouldSetAccessibilityLabel() {
        let sut = makeSUT()
        sut.setText("$500.00", animated: true)
        XCTAssertEqual(sut.accessibilityLabel, "$500.00")
    }

}

private extension RotatingLabelTests {
    func makeSUT() -> RotatingLabel {
        return RotatingLabel()
    }
}
