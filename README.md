# QmlTui Project Template

Starter repository for building cross-platform, retained-mode terminal UI applications with **[QmlTui](https://github.com/qmltui/qmltui)** (`Qt6::Core` + `Qt6::Qml`, C++17 — no `QtQuick`, no `QtGui`, no display server).

Click **[Use this template](https://github.com/qmltui/template/generate)** on GitHub to create your own repository.

## What's Included

- **Dual `find_package` + `FetchContent` CMake setup** (`CMakeLists.txt` + `CMakePresets.json`) with unified `build/bin/` output for Windows DLLs and `qmltui-runner`.
- **C++17 + QML wiring** (`src/AppController.{h,cpp}` exposed via `QML_ELEMENT` to `qml/Main.qml` using `QmlTui` and `QmlTui.Controls`).
- **Headless `Runner` smoke test** (`tests/test_smoke.js`) integrated with CTest on a deterministic virtual clock (omitted automatically in release builds via `-DBUILD_TESTING=OFF`).
- **WebAssembly support** via `qmltui_wasm_app()` (`xterm.js` browser bundle with zero code changes).
- **Editor & formatting setup**: `qmlls` (`.qmlls.ini`), `clangd` (`compile_commands.json`), `Runner` JS completion (`jsconfig.json` + `.qmltui/qmltui-runner.d.ts`), `.vscode/`, `.clang-format`, and `.qmlformat.ini`.
- **Cross-platform GitHub Actions CI** (`.github/workflows/ci.yml`) running build, `qmllint`, `ctest`, and multi-viewport `qmltui-runner --sweep` checks on Linux, macOS, and Windows (plus a manual WebAssembly job).
- **Coding-agent workflow** (`AGENTS.md`) compatible with QmlTui's portable skills (`npx skills add qmltui/qmltui`).

## Prerequisites

- **CMake 3.21+**, **Ninja**, and a **C++17** compiler
- **Qt 6.8+** with `Core` and `Qml` (tested on Qt 6.8–6.12; see [Installing Qt 6.8+](https://qmltui.github.io/getting-started#prerequisites))

## Quickstart

### 1. Rename the Template (30 seconds)

After creating your repo from this template, replace the default names:

- `my_app` → your executable / project name in `CMakeLists.txt`, `.github/workflows/ci.yml`, and `AGENTS.md`
- `MyApp` → your QML module URI in `CMakeLists.txt`, `src/main.cpp`, and `qml/Main.qml`
- Replace `LICENSE` with your preferred license and copyright holder

### 2. Build and Run

```sh
# System Qt 6.8+ on PATH:
cmake --preset dev
cmake --build --preset dev --parallel
./build/bin/my_app

# Or point CMake at a specific Qt 6.8+ kit (Ubuntu 24.04 aqtinstall, macOS Homebrew, Windows):
cmake --preset dev -DCMAKE_PREFIX_PATH=/path/to/Qt/6.8.x/gcc_64
cmake --build --preset dev --parallel
./build/bin/my_app
```

> **Windows**: Configure from a Visual Studio Developer Prompt, add `<Qt>\bin` to `PATH`, and run `.\build\bin\my_app.exe` in **Windows Terminal**.

Press **Enter** or **Space** to increment the counter, **Tab** to move focus between buttons, **Ctrl+R** to reset, and **Q** or **Escape** to quit.

### 3. Lint, Test, and Visually Probe

```sh
# Static-lint all QML files:
cmake --build build --target my_app_qmllint

# Run headless Runner tests in CTest:
ctest --preset dev

# Sweep 60x18 / 80x24 / 120x36 viewports with 0-based (x, y) rulers and idle-repaint check:
./build/bin/qmltui-runner --clock virtual --sweep --idle-ms 300 --ruler --styled -- ./build/bin/my_app
```

### 4. Production Release Build (No `Runner`)

```sh
cmake --preset release
cmake --build --preset release --parallel
./build-release/bin/my_app
```

### 5. Use an Installed QmlTui Package or Local Checkout (Optional)

- **Installed `QmlTui` (`find_package`)**: Pass `-DCMAKE_PREFIX_PATH="/your/qmltui/prefix;/path/to/Qt/6.x/gcc_64"`. `CMakeLists.txt` automatically uses `find_package(QmlTui 0.6)` instead of `FetchContent`.
- **Local `qmltui` checkout**: Pass `-DFETCHCONTENT_SOURCE_DIR_QMLTUI=/path/to/qmltui`.

### 6. Build for WebAssembly (Optional)

With a Qt 6.8+ `wasm_singlethread` kit and matching `emsdk` activated (see the [WebAssembly Guide](https://qmltui.github.io/guides/webassembly)):

```sh
source ~/emsdk/emsdk_env.sh
/path/to/Qt/6.11.x/wasm_singlethread/bin/qt-cmake -S . -B build-wasm -G Ninja \
  -DCMAKE_BUILD_TYPE=MinSizeRel \
  -DBUILD_TESTING=OFF
cmake --build build-wasm --parallel
python3 -m http.server -d build-wasm/bin 8000
```

Open `http://localhost:8000/my_app.html` in a browser.

## Adding More QML Components

Put new uppercase `.qml` components under `qml/` (for example `qml/StatusBar.qml`), add them to `QML_FILES` in `CMakeLists.txt`, and set `QT_RESOURCE_ALIAS` so they resolve unqualified across the module:

```cmake
set_source_files_properties(qml/StatusBar.qml PROPERTIES
    QT_RESOURCE_ALIAS StatusBar.qml
)
```

## Documentation

- [QmlTui Documentation](https://qmltui.github.io/)
- [Getting Started Tutorial](https://qmltui.github.io/getting-started)
- [Build & CMake Configuration](https://qmltui.github.io/build-configuration)
- [Editor & IDE Setup](https://qmltui.github.io/guides/editor-setup)
- [Testing & Recording with Runner](https://qmltui.github.io/guides/testing)
- [Agentic Development Loop](https://qmltui.github.io/guides/agentic-development)

## License

This template is licensed under the **BSD-3-Clause** license so you can freely copy, modify, and relicense it for your own projects. QmlTui itself is licensed under `LGPL-3.0-only` (see [QmlTui Licensing](https://github.com/qmltui/qmltui/blob/main/LICENSE.md)).
