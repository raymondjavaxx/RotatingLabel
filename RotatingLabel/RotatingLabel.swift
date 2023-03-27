//
//  RotatingLabel.swift
//  RotatingLabel
//
//  Created by Ramon Torres on 3/16/23.
//

import UIKit

/// A label that animates when its text changes.
public class RotatingLabel: UIView {
    /// Direction of the animation.
    public enum Direction {
        /// Incrementing direction.
        case increment
        /// Decrementing direction.
        case decrement
    }

    /// Text color.
    public var textColor: UIColor = .label {
        didSet {
            updateTextColor()
        }
    }

    /// Color to flash when values increase.
    public var incrementingColor: UIColor = .systemGreen

    /// Color to flash when values decrease.
    public var decrementingColor: UIColor = .systemRed

    /// Font to use for rendering the text.
    public var font: UIFont? {
        didSet {
            updateFont()
        }
    }

    /// A Boolean that indicates whether the label automatically updates its font when the device’s content size category changes.
    public var adjustsFontForContentSizeCategory: Bool = false {
        didSet {
            updateContentSizeCategoryAdjustmentPreference()
        }
    }

    /// Function to use for diffing the old and new values.
    public var diffingFunction: DiffingFunction = .default

    /// The current text.
    public var text: String? {
        get { internalText }
        set {
            setText(newValue ?? "", animated: false)
        }
    }

    /// Duration of the animation.
    public var animationDuration: TimeInterval = 0.2

    /// Timing parameters of the animation.
    ///
    /// Use `UISpringTimingParameters` to create a "springy" animation or `UICubicTimingParameters` to create a
    /// cubic bezier timing curve.
    ///
    /// - [UISpringTimingParameters](https://developer.apple.com/documentation/uikit/uispringtimingparameters)
    /// - [UICubicTimingParameters](https://developer.apple.com/documentation/uikit/uicubictimingparameters)
    public var animationTimingParameters: UITimingCurveProvider = UISpringTimingParameters(
        mass: 0.03,
        stiffness: 20,
        damping: 0.9,
        initialVelocity: CGVector(dx: 4.8, dy: 4.8)
    )

    public override var intrinsicContentSize: CGSize {
        var width = CGFloat.zero
        var height = CGFloat.zero

        for frame in calculateFrames() {
            width += frame.value.width
            height = max(height, frame.value.height)
        }

        return CGSize(width: width, height: height)
    }

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        return intrinsicContentSize
    }

    private var internalText: String? {
        didSet {
            accessibilityLabel = internalText
        }
    }

    private var labels: [UILabel] = []

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        isAccessibilityElement = true
        accessibilityTraits = .staticText
    }

    /// Sets the text of the label.
    ///
    /// This method will automatically determine the direction of the animation based on the old and new text. Depending
    /// on how the text is formatted, the animation direction might not be always correct. In that case, use `setText(_:animated:direction:)`.
    ///
    /// - Parameters:
    ///   - newText: The new text.
    ///   - animated: Whether to animate the change or not.
    public func setText(_ newText: String?, animated: Bool) {
        let direction: Direction = (newText ?? "") >= (internalText ?? "")
            ? .increment
            : .decrement

        setText(newText, animated: animated, direction: direction)
    }

    /// Sets the text of the label.
    ///
    /// - Parameters:
    ///   - newText: The new text.
    ///   - animated: Whether to animate the change or not.
    ///   - direction: The direction of the animation.
    public func setText(_ newText: String?, animated: Bool, direction: Direction) {
        guard newText != internalText else { return }
        updateContent(from: internalText ?? "", to: newText ?? "", animated: animated, direction: direction)
        internalText = newText
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        let frames = calculateFrames()
        for label in labels {
            label.frame = frames[ObjectIdentifier(label), default: label.frame]
        }
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            setNeedsLayout()
            invalidateIntrinsicContentSize()
        }
    }
}

extension RotatingLabel {
    private static var defaultFontSize: CGFloat {
#if os(tvOS)
        return 16
#else
        return UIFont.labelFontSize
#endif
    }

    // swiftlint:disable:next function_body_length
    private func updateContent(
        from oldText: String,
        to newText: String,
        animated: Bool,
        direction: Direction
    ) {
        var toBeRemoved: [UILabel] = []
        var newLabels: [UILabel] = []

        let diff = diffingFunction(from: oldText, to: newText)
        for operation in diff {
            switch operation {
            case .remove(offset: let offset, element: _):
                let label = labels.remove(at: offset)
                toBeRemoved.append(label)
            case .insert(offset: let offset, element: let element):
                let label = UILabel()
                label.text = String(element)
                label.font = font
                label.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory

                labels.insert(label, at: offset)
                newLabels.append(label)

                addSubview(label)
            }
        }

        if animated {
            let frames = calculateFrames()

            let translationOffset = font?.pointSize ?? Self.defaultFontSize

            newLabels.forEach { label in
                label.frame = frames[ObjectIdentifier(label), default: label.frame]
                label.alpha = 0

                label.transform = CGAffineTransform(
                    translationX: 0,
                    y: direction == .increment ? translationOffset : -translationOffset
                ).scaledBy(x: 0.7, y: 0.7)

                label.textColor = direction == .increment
                    ? incrementingColor
                    : decrementingColor
            }

            let animator = UIViewPropertyAnimator(duration: animationDuration, timingParameters: animationTimingParameters)
            animator.isInterruptible = true

            animator.addAnimations { [self] in
                toBeRemoved.forEach { label in
                    label.alpha = 0
                    label.transform = CGAffineTransform(
                        translationX: 0,
                        y: direction == .increment ? -translationOffset : translationOffset
                    ).scaledBy(x: 0.5, y: 0.5)
                }

                newLabels.forEach { label in
                    label.alpha = 1
                    label.transform = .identity
                }

                labels.forEach { label in
                    label.frame = frames[ObjectIdentifier(label), default: label.frame]
                }
            }

            animator.addCompletion { [self] _ in
                toBeRemoved.forEach { $0.removeFromSuperview() }
                newLabels.forEach { $0.textColor = textColor }
            }

            animator.startAnimation()
        } else {
            toBeRemoved.forEach { $0.removeFromSuperview() }
            setNeedsLayout()
        }

        invalidateIntrinsicContentSize()
    }

    private func calculateFrames() -> [ObjectIdentifier: CGRect] {
        var result: [ObjectIdentifier: CGRect] = [:]

        var x: CGFloat = 0

        for label in labels {
            let size = label.intrinsicContentSize

            result[ObjectIdentifier(label)] = CGRect(x: x, y: 0, width: size.width, height: size.height)
            x += size.width
        }

        return result
    }
}

// MARK: - Appearance

extension RotatingLabel {
    private func updateFont() {
        for label in labels {
            label.font = font
        }

        invalidateIntrinsicContentSize()
    }

    private func updateTextColor() {
        for label in labels {
            label.textColor = textColor
        }
    }

    private func updateContentSizeCategoryAdjustmentPreference() {
        for label in labels {
            label.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory
        }

        invalidateIntrinsicContentSize()
    }
}
