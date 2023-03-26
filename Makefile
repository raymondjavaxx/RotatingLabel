.PHONY: all build build_ios build_tvos test lint format

all: lint format build test

build: build_ios build_tvos

build_ios:
	set -o pipefail && xcodebuild build\
		-sdk iphoneos\
		-destination 'platform=iOS Simulator,name=iPhone 14,OS=latest'\
		-scheme 'RotatingLabel'\
		-derivedDataPath '.build/derivedData'\
		| xcpretty

build_tvos:
	set -o pipefail && xcodebuild build\
		-sdk appletvos\
		-destination 'platform=tvOS Simulator,name=Apple TV,OS=latest'\
		-scheme 'RotatingLabel'\
		-derivedDataPath '.build/derivedData'\
		| xcpretty

test:
	set -o pipefail && xcodebuild test\
		-sdk iphoneos\
		-destination 'platform=iOS Simulator,name=iPhone 14,OS=latest'\
		-scheme 'RotatingLabel'\
		-derivedDataPath '.build/derivedData'\
		| xcpretty

lint:
	swiftlint

format:
	swiftlint --fix
