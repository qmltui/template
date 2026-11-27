cmake_minimum_required(VERSION 3.21)
project(my_app VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Place executables and FetchContent shared libraries (QmlTui*.dll on Windows,
# plus qmltui-runner) in a single bin/ directory.
if(NOT DEFINED CMAKE_RUNTIME_OUTPUT_DIRECTORY)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
endif()

find_package(Qt6 6.8 REQUIRED COMPONENTS Core Qml)
qt_standard_project_setup(REQUIRES 6.8)
include(CTest)

# Use an installed QmlTui package when available (unless overridden with
# -DFETCHCONTENT_SOURCE_DIR_QMLTUI=<path>), otherwise fetch from GitHub.
if(NOT FETCHCONTENT_SOURCE_DIR_QMLTUI)
    find_package(QmlTui 0.6 QUIET COMPONENTS Core Controls OPTIONAL_COMPONENTS Runner)
endif()

if(NOT TARGET QmlTui::Core)
    include(FetchContent)
    FetchContent_Declare(
        QmlTui
        GIT_REPOSITORY https://github.com/qmltui/qmltui.git
        GIT_TAG        main # Pin a release tag (e.g. v0.6.0) once published
        GIT_SHALLOW    TRUE
    )
    FetchContent_MakeAvailable(QmlTui)
endif()

set(QT_QML_GENERATE_QMLLS_INI ON)

# Order QmlTui's build-tree QML metadata before qmlcachegen/qmllint when built
# from source; find_package(QmlTui) provides IMPORTED targets and configures
# QT_QML_IMPORT_PATH automatically instead.
set(_app_qml_dependencies)
get_target_property(_qmltui_imported QmlTui::Core IMPORTED)
if(NOT _qmltui_imported)
    list(APPEND _app_qml_dependencies
        DEPENDENCIES
            TARGET QmlTui::Core
            TARGET QmlTui::Controls
    )
endif()
unset(_qmltui_imported)

# Expose qml/*.qml files at the module root so loadFromModule("MyApp", "Main")
# and unqualified sibling component lookups work cleanly under Qt's QTP0001.
set_source_files_properties(qml/Main.qml PROPERTIES
    QT_RESOURCE_ALIAS Main.qml
)

qt_add_executable(my_app
    src/main.cpp
)

qt_add_qml_module(my_app
    URI MyApp
    SOURCES
        src/AppController.h
        src/AppController.cpp
    QML_FILES
        qml/Main.qml
    ${_app_qml_dependencies}
)
unset(_app_qml_dependencies)

# Generated QML type registrations include QML_ELEMENT headers by bare filename.
target_include_directories(my_app PRIVATE
    "${CMAKE_CURRENT_SOURCE_DIR}/src"
)

target_link_libraries(my_app PRIVATE
    Qt6::Core
    Qt6::Qml
    QmlTui::Core
    QmlTui::Controls
)

if(COMMAND qmltui_wasm_app)
    qmltui_wasm_app(my_app)
endif()

if(BUILD_TESTING AND TARGET QmlTui::Runner)
    target_link_libraries(my_app PRIVATE QmlTui::Runner)
    qmltui_scenario_editor_support()
    qmltui_add_scenario(
        NAME my_app_smoke
        TARGET my_app
        SCRIPT "${CMAKE_CURRENT_SOURCE_DIR}/tests/test_smoke.js"
        COLUMNS 80
        ROWS 24
        CLOCK VIRTUAL
    )
endif()
