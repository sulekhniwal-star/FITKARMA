# FitKarma Makefile

.PHONY: get build watch clean

get:
	flutter pub get

build:
	dart run build_runner build --delete-conflicting-outputs

watch:
	dart run build_runner watch --delete-conflicting-outputs

clean:
	flutter clean
	flutter pub get
