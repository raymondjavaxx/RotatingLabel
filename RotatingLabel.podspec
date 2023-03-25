Pod::Spec.new do |spec|
  spec.name         = "RotatingLabel"
  spec.version      = "1.0.0"
  spec.summary      = "A label that animates text changes by scrolling characters."

  spec.description  = <<-DESC
    RotatingLabel is a label that animates text changes by scrolling characters. The component is designed for presenting numeric values, such as account balances and stock prices, but can be used for any text.
  DESC

  spec.homepage     = "https://github.com/raymondjavaxx/RotatingLabel"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Ramon Torres" => "raymondjavaxx@gmail.com" }

  spec.platform     = :ios, "13.0"
  spec.swift_version = "5.7"

  spec.source       = { :git => "https://github.com/raymondjavaxx/RotatingLabel.git", :tag => "#{spec.version}" }
  spec.source_files = "RotatingLabel/**/*.swift"
end
