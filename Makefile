.PHONY: all build build_ios build_tvos build_docs test lint format

all: lint format build test

build: build_ios build_tvos

build_ios:
	set -o pipefail && NSUnbufferedIO=YES xcodebuild build-for-testing\
		-sdk iphoneos\
		-destination 'platform=iOS Simulator,name=iPhone 14,OS=latest'\
		-scheme 'RotatingLabel'\
		-derivedDataPath '.build/derivedData'\
		| xcpretty

build_tvos:
	set -o pipefail && NSUnbufferedIO=YES xcodebuild build\
		-sdk appletvos\
		-destination 'platform=tvOS Simulator,name=Apple TV,OS=latest'\
		-scheme 'RotatingLabel'\
		-derivedDataPath '.build/derivedData'\
		| xcpretty

build_docs:
	xcodebuild docbuild\
		-scheme 'RotatingLabel'\
		-derivedDataPath '.build/derivedData'\
		-destination generic/platform=iOS\
		| xcpretty

test:
	set -o pipefail && NSUnbufferedIO=YES xcodebuild test-without-building\
		-sdk iphoneos\
		-destination 'platform=iOS Simulator,name=iPhone 14,OS=latest'\
		-scheme 'RotatingLabel'\
		-derivedDataPath '.build/derivedData'\
		| xcpretty

lint:
	swiftlint

format:
	swiftlint --fix
