//
//  DiffingFunction.swift
//  RotatingLabel
//
//  Created by Ramon Torres on 3/16/23.
//

/// A function that computes the difference between two strings.
public struct DiffingFunction {
    /// Operation that can be performed on a string.
    public enum Operation: Equatable {
        /// Insert a character at the given offset.
        case insert(offset: Int, element: Character)
        /// Remove a character at the given offset.
        case remove(offset: Int, element: Character)
    }

    let diff: (String, String) -> [Operation]

    /// Creates a new `DiffingFunction` with the given diffing function.
    ///
    /// - Parameters:
    ///   - diff: A function that computes the difference between two strings.
    public init(_ diff: @escaping (String, String) -> [Operation]) {
        self.diff = diff
    }

    /// Calls the diff function.
    ///
    /// - Parameters:
    ///   - oldValue: Old value.
    ///   - newValue: New value.
    /// - Returns: The difference between old value and new value.
    public func callAsFunction(from oldValue: String, to newValue: String) -> [Operation] {
        return self.diff(oldValue, newValue)
    }
}

public extension DiffingFunction {
    /// A diffing function that uses `String.difference(from:)` to compute the difference between two strings.
    static var system: DiffingFunction {
        DiffingFunction { oldValue, newValue in
            let changes = newValue.difference(from: oldValue)
            return changes.map { change in
                switch change {
                case .insert(offset: let offset, element: let element, associatedWith: _):
                    return .insert(offset: offset, element: element)
                case .remove(offset: let offset, element: let element, associatedWith: _):
                    return .remove(offset: offset, element: element)
                }
            }
        }
    }

    /// The default diffing function.
    ///
    /// This function minimizes shifting by always removing the first character that doesn't match.
    static var `default`: DiffingFunction {
        DiffingFunction { oldValue, newValue in
            var insertions: [Operation] = []
            var removals: [Operation] = []

            let newChars = Array(newValue)
            let oldChars = Array(oldValue)

            for (index, char) in newValue.enumerated() {
                if index >= oldChars.count {
                    insertions.append(.insert(offset: index, element: char))
                    continue
                }

                if char != oldChars[index] {
                    removals.append(.remove(offset: index, element: oldChars[index]))
                    insertions.append(.insert(offset: index, element: char))
                }
            }

            if newChars.count < oldChars.count {
                for index in newChars.count..<oldChars.count {
                    removals.append(.remove(offset: index, element: oldChars[index]))
                }
            }

            return removals.reversed() + insertions
        }
    }

    /// A diffing function that groups insertions from the first character that doesn't match.
    static var grouped: DiffingFunction {
        DiffingFunction { oldValue, newValue in
            var insertions: [Operation] = []
            var removals: [Operation] = []

            let newChars = Array(newValue)
            let oldChars = Array(oldValue)

            let startIndex = zip(oldChars.indices, newChars.indices)
                .first { oldChars[$0] != newChars[$1] }
                .map { $0.0 } ?? 0

            if startIndex < oldChars.count {
                for index in startIndex..<oldChars.count {
                    removals.append(.remove(offset: index, element: oldChars[index]))
                }
            }

            if startIndex < newChars.count {
                for index in startIndex..<newChars.count {
                    insertions.append(.insert(offset: index, element: newChars[index]))
                }
            }

            return removals.reversed() + insertions
        }
    }
}
