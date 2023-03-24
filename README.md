# RotatingLabel

RotatingLabel is a label that animates text changes by scrolling characters. The component was designed for presenting numeric values, such as account balances and stock prices, but it can be used for any text, although not ideal.

## Installation

To install RotatingLabel using [Swift Package Manager](https://github.com/apple/swift-package-manager), add the following to your `Package.swift` file:

```swift
.package(url: "https://github.com/raymondjavaxx/RotatingLabel.git", from: "1.0.0")
```

Or, follow the instructions on the *[Adding package dependencies to your app](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app)* guide.

## Usage

Usage is simple. Just create a RotatingLabel and set the text property to the value you want to display. When it is time to change the value, use the `setText(_:animated:)` method to animate the change.

```swift
let label = RotatingLabel()
label.text = "$100.00"

// ...

label.setText("$155.00", animated: true)
```

## Customization

### Animation

You can customize the animation length and timing parameters by setting the `animationDuration` and `animationTimingParameters` properties.

```swift
label.animationDuration = 0.3
label.animationTimingParameters = UICubicTimingParameters(animationCurve: .easeInOut)
```

### Diffing Function

RotatingLabel uses a diffing function to determine which characters need to be animated. You can use the `diffingFunction` property to use any of the built-in diffing functions or provide your own.

```swift
label.diffingFunction = DiffingFunction { oldValue, newValue in
    var changes: [Operation] = []

    // Your custom diffing logic here

    return changes
}
```

### Dynamic Type

RotatingLabel supports Dynamic Type. To enable it, set the `adjustsFontForContentSizeCategory` property to `true`. The label will automatically adjust its font size when the user changes the content size category.

Note: The font must support scaling for this to work. See [Scaling Fonts Automatically](https://developer.apple.com/documentation/uikit/uifont/scaling_fonts_automatically#3111283) for more information.

## License

RotatingLabel is available under the MIT license. See [LICENSE](LICENSE) for more info.
