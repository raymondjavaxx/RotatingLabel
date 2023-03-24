//
//  RotatingLabelSnapshotTests.swift
//  RotatingLabelTests
//
//  Created by Ramon Torres on 3/23/23.
//

import XCTest
import RotatingLabel
import SnapshotTesting

final class RotatingLabelSnapshotTests: XCTestCase {

    func test_default() {
        let sut = makeSUT()
        sut.value = "$1399.99"
        assertSnapshot(matching: sut, as: .image)
    }

    func test_darkMode() {
        let sut = makeSUT()
        sut.value = "$1399.99"
        assertSnapshot(matching: sut, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }

}

private extension RotatingLabelSnapshotTests {
    func makeSUT() -> RotatingLabel {
        return RotatingLabel()
    }
}
