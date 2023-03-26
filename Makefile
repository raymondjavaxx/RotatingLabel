.PHONY: all build build_ios build_tvos test lint format

all: lint format build test

build: build_ios build_tvos

build_ios:
	xcodebuild build\
		-sdk iphoneos\
		-destination 'platform=iOS Simulator,name=iPhone 14,OS=latest'\
		-scheme 'RotatingLabel'\
		-derivedDataPath '.build/derivedData'\
		| xcpretty

build_tvos:
	xcodebuild build\
		-sdk appletvos\
		-destination 'platform=tvOS Simulator,name=Apple TV,OS=latest'\
		-scheme 'RotatingLabel'\
		-derivedDataPath '.build/derivedData'\
		| xcpretty

test:
	xcodebuild test\
		-sdk iphoneos\
		-destination 'platform=iOS Simulator,name=iPhone 14,OS=latest'\
		-scheme 'RotatingLabel'\
		-derivedDataPath '.build/derivedData'\
		| xcpretty

lint:
	swiftlint

format:
	swiftlint --fix
