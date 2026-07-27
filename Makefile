# Configuration
APP_NAME := FocusBlur
BUNDLE := $(APP_NAME).app
CONFIG := release

SOURCE_DIR := Sources/FocusBlur
ASSETS_DIR := $(SOURCE_DIR)/Assets.xcassets
ICONSET := $(ASSETS_DIR)/AppIcon.appiconset
PLIST := patches/Info.plist
ENTITLEMENTS := $(SOURCE_DIR)/FocusBlur.entitlements

CONTENTS := $(BUNDLE)/Contents
BUNDLE_RESOURCES := $(CONTENTS)/Resources
MACOS_DIR := $(CONTENTS)/MacOS
BUILD_BIN := .build/release/$(APP_NAME)

.PHONY: all build clean run install icon reset-tcc

# Default target
all: build sign

build: $(BUNDLE) sign

$(BUNDLE): icon Package.swift $(wildcard Sources/*/*.plist) $(wildcard Sources/*/*.swift)
	@swift build -c $(CONFIG)

	@echo "Refreshing app bundle structure..."
	@rm -rf $(BUNDLE)
	@mkdir -p $(MACOS_DIR) $(BUNDLE_RESOURCES)
	@echo "Packaging executable and assets..."
	@cp $(BUILD_BIN) $(MACOS_DIR)/$(APP_NAME)
	@cp $(PLIST) $(CONTENTS)/Info.plist
	@cp AppIcon.icns $(BUNDLE_RESOURCES)/AppIcon.icns
	@echo "Ad-hoc code signing bundle..."
	@echo "Refreshing LaunchServices..."
	@/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f $(BUNDLE)
	@touch $(BUNDLE)
	@echo "Built $(BUNDLE)"

# Sign the app bundle
sign:
	@echo "Signing $(BUNDLE) with entitlements..."
	@codesign --force --deep --entitlements $(ENTITLEMENTS) --sign - $(BUNDLE)
	@echo "App bundle signed."

# Icon compilation
icon: $(ICONSET)
	@./patches/icns_fix.py 
	@echo "Built AppIcon.icns"

# Utilities
install:
	@echo "Installing to /Applications..."
	@rm -rf /Applications/$(BUNDLE)
	@cp -R $(BUNDLE) /Applications/
	@echo "$(APP_NAME) installed to /Applications"

reset-tcc:
	@echo "Resetting Accessibility permissions for $(APP_NAME)..."
	@tccutil reset Accessibility Heness.FocusBlur || true

clean:
	@echo "Cleaning up..."
	@swift package clean
	@rm -rf $(BUNDLE) AppIcon.icns .build
