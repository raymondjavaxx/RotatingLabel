//
//  DiffingFunctionTests.swift
//  RotatingLabelTests
//
//  Created by Ramon Torres on 3/16/23.
//

import XCTest
@testable import RotatingLabel

final class DiffingFunctionTests: XCTestCase {
    func test_diff() {
        let operations = DiffingFunction.default(from: "20.00", to: "21.00")
        XCTAssertEqual(operations, [
            .remove(offset: 1, element: "0"),
            .insert(offset: 1, element: "1")
        ])
    }

    func test_diff_onlyInserts() {
        let operations = DiffingFunction.default(from: "", to: "20.00")
        XCTAssertEqual(operations, [
            .insert(offset: 0, element: "2"),
            .insert(offset: 1, element: "0"),
            .insert(offset: 2, element: "."),
            .insert(offset: 3, element: "0"),
            .insert(offset: 4, element: "0")
        ])
    }

    func test_diff_removalShouldBeInReverseOrder() {
        let operations = DiffingFunction.default(from: "20.00", to: "")
        XCTAssertEqual(operations, [
            .remove(offset: 4, element: "0"),
            .remove(offset: 3, element: "0"),
            .remove(offset: 2, element: "."),
            .remove(offset: 1, element: "0"),
            .remove(offset: 0, element: "2")
        ])
    }

    func test_diff_applyingOperationsShouldProduceTargetValue() {
        let target = "\(Double.random(in: 0...10_000))"
        let operations = DiffingFunction.default(from: "353.99", to: target)

        var result = Array("353.99")
        for operation in operations {
            switch operation {
            case .remove(offset: let offset, element: _):
                result.remove(at: offset)
            case .insert(offset: let offset, element: let character):
                result.insert(character, at: offset)
            }
        }

        XCTAssertEqual(String(result), target)
    }
}
