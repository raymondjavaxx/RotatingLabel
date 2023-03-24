.PHONY: all build test lint format

all: lint format build test

build:
	xcodebuild build-for-testing \
		-sdk iphoneos\
		-destination 'platform=iOS Simulator,name=iPhone 14,OS=latest'\
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
