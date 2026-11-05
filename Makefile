.PHONY: build test dev app install clean

build:
	swift build --disable-sandbox

test:
	swift test --disable-sandbox

# Fast dev loop: debug build, kill any running Boarder (debug or app bundle), relaunch debug binary.
dev: build
	@pkill -x Boarder 2>/dev/null || true
	@sleep 0.3
	.build/debug/Boarder >/tmp/boarder-dev.log 2>&1 &
	@echo "Boarder relaunched (debug build) - logs: /tmp/boarder-dev.log"

# Release build, .app bundle, ad-hoc codesign - see Scripts/build_app.sh for details.
app:
	Scripts/build_app.sh

# Build the release app bundle and install it into /Applications.
install: app
	@pkill -x Boarder 2>/dev/null || true
	@sleep 0.3
	rm -rf /Applications/Boarder.app
	cp -R Boarder.app /Applications/Boarder.app
	@echo "Installed /Applications/Boarder.app"

clean:
	rm -rf .build Boarder.app
