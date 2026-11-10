# AGENTS.md — Boarder

Boarder is a menu-bar clipboard history app (no Dock icon) built as a Swift 6 package. It keeps the last 50 text and image copies. Features are in [docs/README.md](docs/README.md). Requires macOS 13+.

## Commands

- `make test`: `swift test` (`Tests/BoarderTests`).
- `make dev`: debug build, quit any running Boarder, and relaunch `.build/debug/Boarder` (logs in `/tmp/boarder-dev.log`).
- `make app`: Release `.app` bundle with ad-hoc signing (`Scripts/build_app.sh`).
- `make install`: build the bundle and install it in `/Applications`.
- `make clean`: remove `.build` and `Boarder.app`.

## Layout

- `Sources/Boarder/`: `PasteboardWatcher` polls the pasteboard, `ClipboardHistoryStore` holds and persists history, `StatusItemController` and the `History*View` files are the menu-bar UI, and `LaunchAtLogin` handles login items.
- `Tests/BoarderTests/`: XCTest suite.
- `Scripts/`: app bundling, icon generation, and the Claude stop hook.

## Design principles

Follow the [design principles](docs/rules/design-principles.md) for any UI work.

## After changing code

1. `make test`
2. `make dev`
3. Commit right away with a short, one-line message written from the diff. No approval wait in this project (it overrides a global "confirm before commit" rule). `Scripts/stop_hook.sh` enforces this flow.
