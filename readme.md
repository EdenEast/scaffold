# Scaffold

> **Shaded CMake macros and functions**

Scaffold is a cmake library that helps you setup and maintain your cmake scripts. Scaffold is ment to be used as a submodule in your project.

## Quick start
1. Add this repository as a submodule of your project, in `./extlibs/scaffold` or `./3rdparty/scaffold`:

    ```bash
    git submodule add https://github.com/cruizemissile/scaffold.git extlibs/scaffold
    ```

2. Include this repository in your project's CMakeLists:

    ```cmake
    list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/extlibs/scaffold/cmake")
    include(scaffold)
    ```
