# Project Agent Instructions

This application is built with [QmlTui](https://github.com/qmltui/qmltui) (Qt 6.8+, C++17, `QCoreApplication`).

## Optional: Install QmlTui Domain Skills

```bash
npx skills add qmltui/qmltui
```

This adds `qmltui-qml` (QML conventions) and `qmltui-dev-loop` (closed-loop visual and performance auditing).

## Rules

- Build terminal UIs with `QtQml`, `QmlTui`, and `QmlTui.Controls`. Never import `QtQuick` or link `Qt6::Quick`.
- Start new QML files with `pragma ComponentBehavior: Bound` and prefer concrete property types and declarative bindings.
- All item geometry (`x`, `y`, `width`, `height`, margins, padding, spacing) is in integer character cells.
- Preserve a reachable keyboard quit path (`Q` or contextual `Escape` at the root `Terminal`, after closing modals or clearing focused text inputs).
- Do not mark C++ `QML_ELEMENT` classes `final`.

## Build, Lint, and Closed-Loop Verification

```bash
# Configure and build + lint QML:
cmake --preset dev
cmake --build build --target my_app_qmllint my_app qmltui-runner

# Sweep 60x18 / 80x24 / 120x36 viewports with 0-based rulers, styles, and idle-repaint check:
./build/bin/qmltui-runner --clock virtual --sweep --idle-ms 300 --ruler --styled -- ./build/bin/my_app

# Run CTest scenarios:
ctest --preset dev
```

Verify `dirtyDuringPaint=0`, zero idle repaints, clean borders/labels across all three viewports, and `git diff --check` before handoff.
