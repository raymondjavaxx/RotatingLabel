.PHONY: all lint format

all: lint format

lint:
	swiftlint

format:
	swiftlint lint --fix
